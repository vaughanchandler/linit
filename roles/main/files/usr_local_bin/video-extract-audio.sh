#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Extracts audio from video files."
    echo "If there's only one audio track it's copied without re-encoding so the container (extension) must support the codec."
    echo "Single track usage: `basename $0` <input> [extension] ..."
    echo "Multi-track usage:  `basename $0` <input> [-] ..."
    echo "Where '...' represents args passed directly to ffmpeg, like '-an' to remove the audio stream."
    exit
fi

file=$1; shift
ext=${1:-m4a}; shift

audio_stream_count=`ffprobe -loglevel error -show_entries stream=codec_type "$file" | grep -c 'codec_type=audio'`

if [ $audio_stream_count -eq 1 ]; then
    echo "Creating single output file with same number of tracks as input file."
    ffmpeg -hide_banner -i "$file" -c copy -map 0:a $@ "${file%.*}.$ext"
else
    echo "Creating single output file with all input tracks from input file combined."
    ffmpeg -hide_banner -i "$file" -vn -c:a aac -ac $audio_stream_count -filter_complex amerge=inputs=2 $@ "${file%.*}.m4a"
fi
