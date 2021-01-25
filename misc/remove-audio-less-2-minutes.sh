#!/usr/bin/env bash

find "$(pwd)" -type f -print0 | xargs -0 -I {} mediainfo --Inform="General;%Duration%,%CompleteName%" {} > /tmp/list.txt

# Duration is in milliseconds

while IFS=, read -r ms path
do
    if [[ $ms -lt 120000 ]]; then
        if [[ ! -z $path ]]; then
            rm "$path"
        fi
    fi
    
done < /tmp/list.txt
