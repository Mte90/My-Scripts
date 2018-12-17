#!/bin/bash

mkdir /tmp/download
cd /tmp/download

# First download the assets to elaborate
wget [your-url] /tmp/download
unzip download

cd ./amule

# Put in queue
if ls ./*.emulecollection 1> /dev/null 2>&1; then
    ed2k -e *.emulecollection
fi

if ls ./*.torrent 1> /dev/null 2>&1; then
    yes | transmission-remote -a *.torrent --auth transmission:torrent
fi
