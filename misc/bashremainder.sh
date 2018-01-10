#!/bin/bash

# Specify the amount on minutes of the continuos reminder
minutes=15
cutoff_hour=13
runme='firefox http://www.ibreviary.com/m2/breviario.php?s=lodi'
message='Vuoi fare le lodi?'

seconds="$((${minutes} * 60))"

while true; do
    [[ "$(date +%H)" -ge "$cutoff_hour" ]] && exit

    if kdialog --yesno "${message}"; then
        ${runme}
        exit
    else
        sleep ${seconds}
    fi
done
