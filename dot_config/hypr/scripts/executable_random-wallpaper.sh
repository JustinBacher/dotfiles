#!/usr/bin/env bash

cd ~/Wallpapers

function make_video_frame () {
    ffmpeg -y -i $FILE -vf "select=eq(n\,0)" -f image2 -q:v 3 $HOME/.cache/wallpaper_thumb.jpg
    wallust run $HOME/.cache/wallpaper_thumb.jpg
}

while : ; do
    FILE=$(ls | shuf | tail -1)

    if [[ $FILE =~ (.mp4|.mov|.webm) ]]; then
        make_video_frame;
    else
        wallust run $FILE &
    fi

    pkill mpvpaper
    mpvpaper -o "no-audio --panscan=1 --window-maximized=yes input-ipc-server=/tmp/mpv-socket --loop-file=inf --autofit=100%x100%" --fork "*" $FILE

    sleep 10m
done
