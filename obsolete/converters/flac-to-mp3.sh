#!/bin/sh
# Convert FLAC to MP3 VBR
flac -cd CDImage.flac | lame -h - -v --preset cd CDImage.mp3

# Split file
mp3splt -a -d mp3 -c CDImage.flac.cue -o @a-@t CDImage.mp3
rm CDImage.mp3
