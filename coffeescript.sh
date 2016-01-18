#!/bin/bash
#Require apt-get install -y inotify-tools
while inotifywait -rq -e create -e move -e modify -e delete assets/coffee/; do  
    echo "Compiled"
    sed -e '$s/$/\n/' -s assets/coffee/*.coffee | coffee -bcs > assets/js/script.js 
    tmp=$(cat assets/js/script.js) 
    echo -e "jQuery.ready(function(){\n$tmp\n});" > assets/js/script.js
done