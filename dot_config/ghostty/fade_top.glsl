// Organic, slowly morphing opacity blobs: dense (~90%) toward the bottom,
// dissolving into a lighter (~60%) haze at the top.

const float TOP_OPACITY = 0.60;
const float BOTTOM_OPACITY = 0.90;

float hash31(vec3 point) {
    point = fract(point * 0.1031);
    point += dot(point, point.yzx + 33.33);
    return fract((point.x + point.y) * point.z);
}

float valueNoise3D(vec3 point) {
    vec3 cell = floor(point);
    vec3 offset = fract(point);
    offset = offset * offset * offset * (offset * (offset * 6.0 - 15.0) + 10.0);

    float x00 = mix(hash31(cell), hash31(cell + vec3(1.0, 0.0, 0.0)), offset.x);
    float x10 = mix(hash31(cell + vec3(0.0, 1.0, 0.0)),
                    hash31(cell + vec3(1.0, 1.0, 0.0)), offset.x);
    float x01 = mix(hash31(cell + vec3(0.0, 0.0, 1.0)),
                    hash31(cell + vec3(1.0, 0.0, 1.0)), offset.x);
    float x11 = mix(hash31(cell + vec3(0.0, 1.0, 1.0)),
                    hash31(cell + vec3(1.0, 1.0, 1.0)), offset.x);
    return mix(mix(x00, x10, offset.y), mix(x01, x11, offset.y), offset.z);
}

// Two octaves of evolving noise, normalized to 0..1.
float fbm(vec3 point) {
    float value = 0.65 * valueNoise3D(point);
    point = point * 2.03 + vec3(5.2, 1.3, 3.7);
    value += 0.35 * valueNoise3D(point);
    return value;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 terminal = texture(iChannel0, uv);

    // Ghostty uses the Shadertoy convention: uv.y is 1 at the top, 0 at the
    // bottom. `depth` is 0 at the top edge and 1 at the bottom edge.
    float depth = 1.0 - uv.y;
    float aspect = iResolution.x / iResolution.y;
    vec2 p = vec2(uv.x * aspect, depth) * 1.8;
    float t = iTime * 0.07;

    // Gentle domain warping: enough to make the edges flow and roll, not so
    // much that they curl into tendrils.
    vec2 warp = vec2(fbm(vec3(p + vec2(0.0, 1.7), t)),
                     fbm(vec3(p + vec2(4.1, 0.3), t * 1.3 + 9.0)));
    float blobs = fbm(vec3(p + (warp - 0.5) * 0.8, t * 0.8 + 3.0));

    // Mostly-opaque base that thins toward the top: the 60% areas hang from
    // the top edge and only reach mid-window occasionally. Noise is damped at
    // the top edge (settles at 60%) and the bottom edge (settles at 90%).
    float swing = (0.3 + 0.7 * smoothstep(0.0, 0.3, depth)) *
                  (1.0 - 0.5 * smoothstep(0.8, 1.0, depth));
    float density = 0.2 + depth * 0.9 + (blobs - 0.5) * 1.5 * swing;

    // Soft, wide blob edges.
    float body = smoothstep(0.2, 0.8, density);
    float opacity = mix(TOP_OPACITY, BOTTOM_OPACITY, body);

    // Preserve premultiplied alpha while fading the complete terminal image.
    fragColor = terminal * opacity;
}
