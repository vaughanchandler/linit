#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Fixes a video file."
    echo "Usage: `basename $0` <input> ..."
    echo "Where '...' represents args passed directly to ffmpeg, like '-an' to remove the audio stream."
    exit
fi

file=$1; shift

echo ffmpeg -i \"$file\" -c copy $@ \"${file%.*}.fix.${file##*.}\"
ffmpeg -i "$file" -c copy $@ "${file%.*}.fix.${file##*.}"
