#!/usr/bin/env bash

echo "Generating file list"
find "$1" -type f \( -iname \*.mp3 -o -iname \*.flac \) -print0 | xargs -0 -I {} mediainfo --Inform="General;%Duration%,%CompleteName%" {} > /tmp/list.txt

# Duration is in milliseconds

while IFS=, read -r ms path
do
    if [[ $ms -lt 120000 ]]; then
        if [[ ! -z $path ]]; then
            echo "Removing $path"
            rm "$path"
        fi
    fi
    
done < /tmp/list.txt
