#!/bin/bash
shopt -s globstar nullglob
basename=$PWD
for dir in ./**/;do
cd "$basename/$dir" 
echo Optimization on $dir
image_optim -r *.{jpg,png,gif,jpeg}
done