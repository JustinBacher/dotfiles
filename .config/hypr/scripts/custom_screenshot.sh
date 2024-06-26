#!/usr/bin/env bash

screenshot_directory="${$HOME/Pictures}/Screenshots}"
default_date_format="+%d-%m-%Y %H:%M:%S"

# set ffmpeg defaults
ffmpeg() {
  command ffmpeg -hide_banner -loglevel error -nostdin "$@"
}

video_to_gif() {
  ffmpeg -i "$1" -vf palettegen -f image2 -c:v png - |
    ffmpeg -i "$1" -i - -filter_complex paletteuse "$2"
}

countdown() {
  count=4  # Count from 3 to 1 but loop decrements on first iteration so set to 4
  while (( --count > 0 )); do
    notify-send --app-name="screenshot" "Screenshot" "Recording in ${count}" -t 1000
    sleep 1
  done
}

crtc() {
  # TODO: This is what I have in mind just need to make the other functions do the same, then work out the recording stuff
  # maybe using something like this: https://github.com/hyprwm/contrib/issues/5#issuecomment-1798083345
  grimblast copy area FILE=/tmp/screenshot_clip.png
  notify-send --app-name="screenshot" -i /tmp/screenshot_clip.png "Screenshot" "Region copied to Clipboard"
  rm /tmp/screenshot_clip.png
}

crtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to capture"
  dt=$1
  ffcast -q "$(slop -n -f '-g %g ')" png "$screenshot_directory/$dt.png"
  notify-send --app-name="screenshot" "Screenshot" "Region saved to ${screenshot_directory//${HOME}/~}/$dt.png"
}

cstc() {
  ffcast -q png /tmp/screenshot_clip.png
  xclip -selection clipboard -t image/png /tmp/screenshot_clip.png
  rm /tmp/screenshot_clip.png
  notify-send --app-name="screenshot" "Screenshot" "Screenshot copied to Clipboard"
}

cstf() {
  dt=$1
  ffcast -q png "$screenshot_directory/$dt.png"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}/$dt.png"
}

rgrtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to record"
  dt=$1
  ffcast -q "$(slop -n -f '-g %g ' && countdown)" rec /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Converting to gif… (can take a while)"
  video_to_gif /tmp/screenshot_gif.mp4 "$screenshot_directory/$dt.gif"
  rm /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}/$dt.gif"
}

rgstf() {
  countdown
  dt=$1
  ffcast -q rec /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Converting to gif… (can take a while)"
  video_to_gif /tmp/screenshot_gif.mp4 "$screenshot_directory/$dt.gif"
  rm /tmp/screenshot_gif.mp4
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}/$dt.gif"
}

rvrtf() {
  notify-send --app-name="screenshot" "Screenshot" "Select a region to record"
  dt=$1
  ffcast -q "$(slop -n -f '-g %g ' && countdown)" rec "$screenshot_directory/$dt.mp4"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}/$dt.mp4"
}

rvstf() {
  countdown
  dt=$1
  ffcast -q rec "$screenshot_directory/$dt.mp4"
  notify-send --app-name="screenshot" "Screenshot" "Saved to ${screenshot_directory//${HOME}/~}/$dt.mp4"
}

stop_recording() {
  if [ -z "$(pgrep -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*')" ]; then
    notify-send --app-name="screenshot" "Screenshot" "No recording found"
    exit 1
  fi

  pkill -fxn '(/\S+)*ffmpeg\s.*\sx11grab\s.*'
  notify-send --app-name="screenshot" "Screenshot" "Recording stopped"
}

get_options() {
  echo "  Region  Clip"
  echo "  Region  File"
  echo "  Screen  Clip"
  echo "  Screen  File"
  echo "  Region  File (GIF)"
  echo "  Screen  File (GIF)"
  echo "  Region  File (MP4)"
  echo "  Screen  File (MP4)"
  echo "  Stop recording"
}

show_help() {
  echo ### screenshot
  echo "USAGE: screenshot [OPTION] <argument>"
  echo "(no option)"
  echo "    show the screenshot menu"
  echo "-s, --stop"
  echo "    stop recording"
  echo "-h, --help"
  echo "    this screen"
  echo "-d, --directory <directory>"
  echo "    set the screenshot directory"
  echo "-t, --timestamp <format>"
  echo "    set the format used for timestamps, in the format the date"
  echo "    command expects (default '+%d-%m-%Y %H:%M:%S')"
}

check_directory() {
  if [[ ! -d $1 ]]; then
    echo "Directory does not exist!"
    exit 1
  fi
}

main() {
  # rebind long args as short ones
  for arg in "$@"; do
    shift
    case "$arg" in
      '--help') set -- "$@" '-h' ;;
      '--directory') set -- "$@" '-d' ;;
      '--timestamp') set -- "$@" '-t' ;;
      '--stop') set -- "$@" '-s' ;;
      *) set -- "$@" "$arg" ;;
    esac
  done

  # parse short options
  OPTIND=1
  date_format="$default_date_format"
  while getopts "hd:t:s" opt; do
    case "$opt" in
      'h')
        show_help && exit 0
        ;;
      '?')
        show_help && exit 1
        ;;
      'd')
        check_directory $OPTARG
        screenshot_directory="$OPTARG"
        ;;
      't')
        date_format="$OPTARG"
        ;;
      's')
        stop_recording && exit 0
        ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  choice=$( (get_options) | anyrun --plugins libstdin.so)

  if [[ -z "${choice// /}" ]]; then
    exit 1
  fi

  cmd='date "${date_format}"'
  dt=$(eval $cmd)

  case $choice in
    '  Region  Clip')
      crtc
      ;;
    '  Region  File')
      crtf "$dt"
      ;;
    '  Screen  Clip')
      cstc
      ;;
    '  Screen  File')
      cstf "$dt"
      ;;
    '  Region  File (GIF)')
      rgrtf "$dt"
      ;;
    '  Screen  File (GIF)')
      rgstf "$dt"
      ;;
    '  Region  File (MP4)')
      rvrtf "$dt"
      ;;
    '  Screen  File (MP4)')
      rvstf "$dt"
      ;;
    '  Stop recording')
      stop_recording
      ;;
  esac

  # done
  set -e
}

main "$@" &

exit 0

! /bin/bash
