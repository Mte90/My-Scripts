#!/bin/bash

rm -fr /tmp/download
mkdir -p /tmp/download
cd /tmp/download

# First download the assets to elaborate
wget [your-url] /tmp/download
unzip download

cd ./amule

# Put in queue
if ls ./*.emulecollection 1> /dev/null 2>&1; then
    awk 'NF' *.emulecollection
    sed -i '/^[[:space:]]*$/d' *.emulecollection
    ed2k -e *.emulecollection
fi
if ls ./*.amulecollection 1> /dev/null 2>&1; then
    awk 'NF' *.amulecollection
    sed -i '/^[[:space:]]*$/d' *.amulecollection
    ed2k -e *.amulecollection
fi

if ls ./*.torrent 1> /dev/null 2>&1; then
    for i in *.torrent; do
        yes | transmission-remote -a "$i" --auth transmission:transmission
    done
fi

for filename in ./*; do
    [ -e "$filename" ] || continue
    curl --header "Authorization: Basic [atokenstring]" -X DELETE "https://[your-url]/public.php/webdav/$filename"
    rm "./$filename"
done
