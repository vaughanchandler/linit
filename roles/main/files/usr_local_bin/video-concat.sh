#!/bin/bash

if [ $# -lt 3 ]; then
    echo "Concatenates multiple videos."
    echo "The videos must use the same codec and codec properties."
    echo "Usage: `basename $0` <input...> <output>"
    exit
fi

ffmpeg -f concat -safe 0 -i <(for f in "${@:1:$(($#-1))}"; do echo $"file '`realpath \"$f\"`'"; done) -c copy "${@: -1}"
