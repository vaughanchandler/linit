#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Re-encodes a video using h265 with a specific CRF (defaults to 28; 0 is lossless)."
    echo "Usage: `basename $0` <video...> [crf] [args...]"
    echo "Where <crf> is 0 - 51, and <args> are passed directly to ffmpeg, like '-an' to remove the audio stream."
    echo "-- can be used to force all following arguments to be passed to ffmpeg."
    exit
fi

crf=28
files=()
for arg in "$@"; do
    if [[ $arg =~ ^([1-4]?[0-9]|5[01])$ ]]; then
        crf=$arg
        shift
        break
    elif [ "$arg" == "--" ]; then
        shift
        break
    elif [ "$arg" == "-*" ]; then
        break
    elif [ -f "$arg" ]; then
        files+=("$arg")
        shift
    else
        2>&1 echo "Unknown argument: $arg"
        exit 1
    fi
done

map=
if [[ ! $@ =~ "-map" ]]; then
    map="-map 0"
fi

for file in "${files[@]}"; do
    output_file="${file%.*}.opt-$crf.${file##*.}"
    echo ffmpeg -i \"$file\" -c:v libx265 -crf $crf $map $@ \"$output_file\"
    ffmpeg -i "$file" -c:v libx265 -crf $crf $map $@ "$output_file"
done
