#!/bin/bash

# resolution of left monitor
w_l_monitor=1280
h_l_monitor=1024

# window title bar height of differente monitor
h_tbar_l=14
h_tbar_r=80

# focus on active window
window=`xdotool getactivewindow`

# get active window for check the actual monitor
x=`xwininfo -id $window | grep "Absolute upper-left X" | awk '{print $4}'`

# window on left monitor
if [ "$x" -lt "$w_l_monitor" ]; then
	new_x=$((140+$w_l_monitor))
	new_y=$(($h_tbar_r))
	xdotool mousemove $new_x $new_y click 1
	echo 'left'

# window on right monitor
else
	new_x=140
	new_y=$(($h_tbar_l))
	xdotool mousemove $new_x $new_y click 1
	echo 'right' + $new_x
fi