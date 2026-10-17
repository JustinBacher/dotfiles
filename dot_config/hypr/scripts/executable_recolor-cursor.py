#!/usr/bin/env python3
"""Build a palette-matched GoogleDot theme; keep the installed originals intact."""
import argparse
import fcntl
import hashlib
import io
import json
import os
from pathlib import Path
import re
import struct
import subprocess
import tempfile
import xml.etree.ElementTree as ET
import zipfile
from PIL import Image

HOME = Path.home()
CONFIG = Path(os.environ.get('XDG_CONFIG_HOME', HOME / '.config'))
CACHE = Path(os.environ.get('XDG_CACHE_HOME', HOME / '.cache')) / 'noctalia'
ICONS = Path(os.environ.get('XDG_DATA_HOME', HOME / '.local/share')) / 'icons'
ORIGINAL = 'GoogleDot-Black'
THEME = 'GoogleDot-Matugen'
SIZE = '20'


def run(*args):
    result = subprocess.run(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode:
        raise RuntimeError(f'{args[0]} failed: {result.stdout}{result.stderr}')


def apply():
    name = THEME if (ICONS / THEME / 'manifest.hl').exists() else ORIGINAL
    # Switch away first so clients do not reuse the previous palette's cache.
    if os.environ.get('HYPRLAND_INSTANCE_SIGNATURE'):
        run('hyprctl', 'setcursor', ORIGINAL, SIZE)
        run('hyprctl', 'setcursor', name, SIZE)
    run('gsettings', 'set', 'org.gnome.desktop.interface', 'cursor-theme', ORIGINAL)
    run('gsettings', 'set', 'org.gnome.desktop.interface', 'cursor-theme', name)
    run('gsettings', 'set', 'org.gnome.desktop.interface', 'cursor-size', SIZE)


def build(palette):
    colors = json.loads(palette.read_text())
    for key in ('body', 'outline'):
        if not re.fullmatch(r'#[0-9a-fA-F]{6}', colors[key]):
            raise ValueError(f'Invalid {key} color: {colors[key]!r}')
    source = ICONS / ORIGINAL / 'hyprcursors'
    archives = sorted(source.glob('*.hlc'))
    if not archives:
        raise FileNotFoundError(f'Original SVG cursor theme missing: {source}')
    digest = hashlib.sha256(Path(__file__).read_bytes() + palette.read_bytes())
    for archive in archives:
        digest.update(archive.name.encode() + archive.read_bytes())
    fingerprint = digest.hexdigest()
    destination = ICONS / THEME
    if (destination / 'palette.sha256').exists() and (destination / 'palette.sha256').read_text() == fingerprint:
        return
    ICONS.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='.cursor-build-', dir=ICONS) as temporary:
        root = Path(temporary)
        theme = root / THEME
        hc = theme / 'hyprcursors'
        hc.mkdir(parents=True)
        scalable = root / 'scalable'
        aliases = {}
        for archive in archives:
            shape = archive.stem
            shape_dir = scalable / shape
            shape_dir.mkdir(parents=True)
            with zipfile.ZipFile(archive) as src, zipfile.ZipFile(hc / archive.name, 'w', zipfile.ZIP_DEFLATED) as out:
                meta = src.read('meta.hl').decode()
                for alias in re.findall(r'^define_override\s*=\s*(\S+)', meta, re.M):
                    aliases[alias] = shape
                # Preserve the XCursor theme's original hotspot rather than the
                # Hyprcursor metadata's coordinate convention.
                original = Path('/usr/share/icons') / ORIGINAL / 'cursors' / shape
                data = original.read_bytes()
                position = struct.unpack_from('<I', data, 24)[0]
                _, _, _, _, width, height, xhot, yhot, _ = struct.unpack_from('<9I', data, position)
                frames = []
                delays = {m[0]: int(m[1] or 0) for m in re.findall(r'^define_size\s*=\s*\d+,\s*([^,\s]+)(?:,\s*(\d+))?', meta, re.M)}
                for entry in src.namelist():
                    content = src.read(entry)
                    if entry.endswith('.svg'):
                        svg = content.decode()
                        svg = re.sub('#000000', colors['body'], svg, flags=re.I)
                        svg = re.sub('#FFFFFF', colors['outline'], svg, flags=re.I)
                        content = svg.encode()
                        (shape_dir / entry).write_bytes(content)
                        element = ET.fromstring(content)
                        view = [float(v) for v in element.attrib['viewBox'].split()]
                        frames.append({'filename': entry, 'hotspot_x': xhot / width * view[2],
                                       'hotspot_y': yhot / height * view[3],
                                       'nominal_size': view[2], 'delay': delays.get(entry, 0)})
                    out.writestr(entry, content)
                (shape_dir / 'metadata.json').write_text(json.dumps(frames))
        (theme / 'manifest.hl').write_text(f'name = {THEME}\ndescription = GoogleDot recolored from the desktop palette\nversion = 1.0\ncursors_directory = hyprcursors\n')
        (theme / 'index.theme').write_text(f'[Icon Theme]\nName={THEME}\nComment=Palette-matched GoogleDot\nInherits={ORIGINAL}\n')
        cursors = theme / 'cursors'
        cursors.mkdir()
        # Xcursor image chunks use premultiplied ARGB pixels (Xcursor.h).
        for shape_dir in scalable.iterdir():
            chunks = []
            for size in (16, 20, 22, 24, 32, 48, 64):
                for frame in json.loads((shape_dir / 'metadata.json').read_text()):
                    png = subprocess.check_output(['rsvg-convert', '-w', str(size), '-h', str(size),
                                                   str(shape_dir / frame['filename'])])
                    image = Image.open(io.BytesIO(png)).convert('RGBA')
                    pixels = bytearray()
                    for r, g, b, a in struct.iter_unpack('4B', image.tobytes()):
                        pixels.extend(struct.pack('<I', a << 24 | (r*a//255) << 16 | (g*a//255) << 8 | b*a//255))
                    xhot = min(size - 1, round(frame['hotspot_x'] / frame['nominal_size'] * size))
                    yhot = min(size - 1, round(frame['hotspot_y'] / frame['nominal_size'] * size))
                    chunk = struct.pack('<9I', 36, 0xfffd0002, size, 1, size, size, xhot, yhot, frame['delay'])
                    chunks.append((size, chunk + pixels))
            position = 16 + 12 * len(chunks)
            toc = bytearray()
            for size, chunk in chunks:
                toc.extend(struct.pack('<3I', 0xfffd0002, size, position))
                position += len(chunk)
            (cursors / shape_dir.name).write_bytes(struct.pack('<4I', 0x72756358, 16, 0x10000, len(chunks))
                                                 + toc + b''.join(chunk for _, chunk in chunks))
        # Preserve additional XCursor aliases, including hashed cursor names.
        for entry in (Path('/usr/share/icons') / ORIGINAL / 'cursors').iterdir():
            if entry.is_symlink():
                aliases[entry.name] = entry.resolve().name
        for alias, shape in aliases.items():
            target = theme / 'cursors' / alias
            if not target.exists() and (theme / 'cursors' / shape).exists():
                target.symlink_to(shape)
        (theme / 'palette.sha256').write_text(fingerprint)
        # Replace only our generated theme after both formats have built.
        previous = root / 'previous'
        if destination.exists():
            destination.rename(previous)
        try:
            theme.rename(destination)
        except BaseException:
            if previous.exists():
                previous.rename(destination)
            raise
    print(f"Built {THEME}: {colors['body']} body, {colors['outline']} outline")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--palette', type=Path, default=CACHE / 'cursor-palette.json')
    parser.add_argument('--apply-only', action='store_true')
    parser.add_argument('--build-only', action='store_true')
    args = parser.parse_args()
    CACHE.mkdir(parents=True, exist_ok=True)
    with (CACHE / 'cursor-build.lock').open('w') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX)
        if not args.apply_only:
            build(args.palette)
        if not args.build_only:
            apply()


if __name__ == '__main__':
    main()
