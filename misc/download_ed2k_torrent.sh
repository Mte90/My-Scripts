#!/bin/bash

cd /tmp/download

ed2k -e *.emulecollection

transmission-remote -a *.torrent
