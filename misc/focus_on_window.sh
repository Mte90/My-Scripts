#!/bin/bash

if [ "$1" -eq "1" ]; then
    xdotool mousemove 900 5
elif [ "$1" -eq "2" ]; then
    xdotool mousemove 2560 40
elif [ "$1" -eq "3" ]; then
    xdotool mousemove 4000 5
fi
