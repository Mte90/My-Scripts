#!/bin/bash
#Require apt-get install -y inotify-tools
while inotifywait -rq assets/coffee/ -e create -e move -e modify -e delete; do  
    echo "Compiled"
    cat assets/coffee/*.coffee | coffee -bcs > assets/js/script.js && tmp=$(cat assets/js/script.js); echo -e "jQuery.ready(function(){\n$tmp\n});" > assets/js/script.js
done