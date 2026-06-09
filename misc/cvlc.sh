#!/usr/bin/env bash

# Open with CVLC - Dolphin service menu
# %F passa path locali, ogni path è un argomento separato

killall vlc 2>/dev/null

for path in "$@"; do
    cvlc "$path" &
done
wait
