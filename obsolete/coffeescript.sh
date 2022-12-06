#!/bin/bash
# Compile a folder with multiple coffeescript files to a single javascript with sourcemap
# Include a diff percentage
#Require apt-get install -y inotify-tools
while inotifywait -rq -e create -e modify,attrib,move,create,delete assets/coffee/*.coffee; do 
    SIZE1=$(stat -c "%s" "assets/js/script.js")
    sed -e '$s/$/\n/' -s assets/coffee/*.coffee > assets/js/script.coffee
    coffee -bcm -o assets/js assets/js/script.coffee
    rm assets/js/script.coffee
    tmp=$(cat assets/js/script.js) 
    echo -e "jQuery.ready(function(){\n$tmp\n});\n" > assets/js/script.js
    SIZE2=$(stat -c "%s" "assets/js/script.js")
    PERC=$(bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100")
    echo "  Compiled Diff: $PERC%"
done