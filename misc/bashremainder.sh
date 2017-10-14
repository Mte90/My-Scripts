#!/bin/bash

# Specify the amount on minutes of the continuos reminder
minutes=15
cutoff_hour=15
runme='firefox "http://www.ibreviary.com/m2/breviario.php?s=lodi"'
message='Vuoi fare le lodi?'

seconds="$((${minutes} * 60))"

while true; do
    [[ "$(date +%H)" -ge 13 ]] && exit

    if kdialog --yesno "${message}"; then
        ${runme}
    else
        sleep ${seconds}
    fi
done
