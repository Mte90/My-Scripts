#!/bin/sh

#Convert ogv file in gif 
#Author: Mte90

path=/home/mte90
file="$path/out.ogv"

mplayer -ao null "$file" -vo jpeg:outdir=output

echo '# Output multiple images from the input video'

echo '# use ImageMagic "convert" to generate the animated .gif' 
convert $path/output/* $path/output.gif
convert $path/output.gif -fuzz 10% -layers Optimize $path/Desktop/optimised.gif

echo '# remove temp image files'    
rm -r $path/output
rm $path/output.gif
rm -r $file

echo 'Done!' 
