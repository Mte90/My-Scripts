#!/bin/bash

eval $(xdotool getmouselocation --shell)

if [ "$1" -eq "1" ]; then
    xdotool mousemove 900 $Y
elif [ "$1" -eq "2" ]; then
    xdotool mousemove 2560 $Y
elif [ "$1" -eq "3" ]; then
    if [ $Y -gt 700 ]; then
        Y=700
    fi
    xdotool mousemove 4000 $Y
fi
