#!/bin/bash

if [ $# -eq 0 ] || [ "$1" == "-h" ]; then
    echo
    echo "Syncs linit to the specified host/path every time one of the files is changed (to assist with tetsing during development)."
    echo "Multiple space-separated remote host/path pairs can be specified in a format supported by rsync."
    echo "Port 22 on the remote host must be accessible."
    echo "For safety, remote files/folders are never deleted."
    echo
    echo "Usage:    $0 <hostpath...>"
    echo
    echo "Examples: $0 192.168.0.1:/opt/"
    echo "          $0 user@192.168.0.1:/opt/"
    echo
    exit 0
fi

if ! command -v 'inotifywait' &>/dev/null; then
    echo "inotifywait command not found. You probably want to install inotify-tools."
    exit 1
fi

for hostpath in $@; do
    if [[ $hostpath != *":"* ]]; then
        echo "'$hostpath' should be in the format <host>:<path> or <user>@<host>:<path>"
        exit 2
    fi
done

cd "$( dirname "${BASH_SOURCE[0]}" )"

inotifywait -r -e close_write,moved_to,delete_self -m . | while read -r directory events filename; do
    for hostpath in $@; do
        if [[ $directory == *"/.git/"* ]] || [[ $directory == *"/.vscode/"* ]]; then
            continue
        fi
        printf "%s: Syncing to $hostpath because $directory$filename changed... " "`date +%T`"
        rsync --archive --rsh ssh --exclude='.git' "$(pwd)" $hostpath
        echo 'Done'
    done
done
