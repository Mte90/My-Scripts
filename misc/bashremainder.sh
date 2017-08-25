#!/bin/bash

# Specify the amount on minutes of the continuos reminder
minutes=15
runme="firefox http://www.ibreviary.com/m2/breviario.php?s=lodi"
message='Vuoi fare le lodi?'

seconds=$(($minutes * 60))

while true; do
    $(kdialog --yesno "$message")
    if [ "$?" = 0 ]; then
        $($runme)
        break
    else
        sleep $seconds
    fi
done
