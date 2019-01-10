#!/bin/bash

# Install:
#     wp package install codeAtcode/wp-cli-getbyurl
# How to use the script:
#     cat list.txt | xargs -n1 remove-page-by-url.sh

url="https://domain/$1"
out=`wp get-by-url $url --skip-plugins --skip-themes`
command=`cut -d'|' -f1 <<< $out`
id=`cut -d'|' -f2 <<< $out`
taxonomy=`cut -d'|' -f3 <<< $out`
if [ $taxonomy == 'post' ];
    wp $command delete $id --skip-plugins --skip-themes
else
    wp term delete $taxonomy $id --skip-plugins --skip-themes
fi
