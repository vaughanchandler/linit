#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Re-encodes a video using h265 with a specific CRF (defaults to 28; 0 is lossless)."
    echo "Usage: `basename $0` <video> [crf]"
    echo "Or:    `basename $0` <video> <crf> ..."
    echo "Where '...' represents args passed directly to ffmpeg, like '-an' to remove the audio stream."
    exit
fi

file=$1; shift
crf=${1:-28}; shift

# Include all streams, unless a -map CLI arg was specified.
map=
if [[ ! $@ =~ "-map" ]]; then
    map="-map 0"
fi

echo ffmpeg -i \"$file\" -c:v libx265 -crf $crf $map $@ \"${file%.*}.opt-$crf.${file##*.}\"
ffmpeg -i "$file" -c:v libx265 -crf $crf $map $@ "${file%.*}.opt-$crf.${file##*.}"
