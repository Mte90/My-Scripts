#!/usr/bin/env bash

# Convert automatically the odt files in HTML and download the wishlist from IBS>it using the Firefox browser (that I have always open)
# So I can later upload it on my soerver with dolphin

soffice --headless --convert-to htm:HTML --outdir . libri.odt
soffice --headless --convert-to htm:HTML --outdir . ListaVari.odt

firefox-nightly https://www.ibs.it/mio-ibs/lista-desideri/manage/export-wishlist/93242281
sleep 3
mv /home/mte90/Desktop/Libri.csv /media/disk3part1/Backup/Fumetti/LibriNuovi.csv
# 59 is the ASCII value for ; (semicolon), in this way use the right separator for this file
soffice --headless --convert-to htm --outdir . --infilter="Text - txt - csv (StarCalc)":"59,ANSI,1" LibriNuovi.csv

mv ./libri.htm ./libri.html
mv ./ListaVari.htm ./ListaVari.html
mv ./LibriNuovi.htm ./LibriNuovi.html

dolphin ftp://domain/libri
