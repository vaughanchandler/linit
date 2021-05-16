#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Slices out part of a video."
    echo "Times can be specified as seconds, mm:ss or h:mm:ss."
    echo "Usage: `basename $0` <video> <start-time> [end-time]"
    echo "Or:    `basename $0` <video> <start-time> <end-time> ..."
    echo "Where '...' represents args passed directly to ffmpeg, like '-an' to remove the audio stream."
    exit
fi

file=$1; shift
start=$1; shift
end=$1; shift
endstr=${end:-end}
if [ -n "$end" ]; then
    endarg="-to $end"
fi

echo ffmpeg -ss $start $endarg -i \"$file\" -c copy -avoid_negative_ts 1 $@ \"${file%.*}.slice-${start//:}-${endstr//:}.${file##*.}\"
ffmpeg -ss $start $endarg -i "$file" -c copy -avoid_negative_ts 1 $@ "${file%.*}.slice-${start//:}-${endstr//:}.${file##*.}"
