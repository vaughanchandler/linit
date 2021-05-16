#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Re-encodes a video using h265 with a specific CRF (defaults to 28)."
    echo "Usage: `basename $0` <video> [crf]"
    echo "Or:    `basename $0` <video> <crf> ..."
    echo "Where '...' represents args passed directly to ffmpeg, like '-an' to remove the audio stream."
    exit
fi

file=$1; shift
crf=${1:-28}; shift

echo ffmpeg -i \"$file\" -c:v libx265 -crf $crf $@ \"${file%.*}.opt-$crf.${file##*.}\"
ffmpeg -i "$file" -c:v libx265 -crf $crf $@ "${file%.*}.opt-$crf.${file##*.}"
