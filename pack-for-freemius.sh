#!/bin/bash

pluginfolder=$PWD
foldername=`basename $PWD`

echo "Generating the zip in progress..."

cp -ar $PWD /tmp/$foldername

cd /tmp/$foldername

version=`grep "^Stable tag:" README.txt | awk -F' ' '{print $NF}'`

rm -rf ./.git*
rm -rf ./.sass-cache
rm -rf ./node_modules
rm -rf ./wp-config-test.php
rm -rf ./package.json
rm -rf ./Gruntfile.js
rm -rf ./composer.*
rm -rf ./codeception.yml
rm -rf ./.netbeans*
rm -rf ./.php_cs
rm -rf ./admin/assets/sass
rm -rf ./*.zip
#This contain the test stuff
rm -rf ./vendor
rm -rf ./tests

#Remove Fake_Freemius
rm -rf ./includes/Fake_Freemius.php
rowff=`grep -n "/includes/Fake_Freemius.php" $foldername.php | awk -F: '{print $1}'`
rowff+='d'
sed -i "$rowff" $foldername.php
#If Freemius SDK is commented remove the comments
rowfs=`grep -n "/includes/freemius/start.php" $foldername.php | awk -F: '{print $1}'`
rowfs+='s'
sed -i "$rowfs/\/\///" $foldername.php

zip -r $pluginfolder/$foldername-$version.zip ./ > /dev/null

cd ../

rm -rf /tmp/$foldername
cd $pluginfolder

echo "Done!"
