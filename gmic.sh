#!/bin/bash

wget http://ignum.dl.sourceforge.net/project/gmic/gmic_gimp_linux64.zip
unzip ./gmic_gimp_linux64.zip
mv ./gmic_gimp /usr/lib/gimp/2.0/plug-ins/
rm ./gmic_gimp_linux64.zip
rm ./README 
