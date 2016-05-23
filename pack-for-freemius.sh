#!/bin/bash

foldername=`basename $PWD`
pluginfolder=$PWD

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
#This contain the test stuff
rm -rf ./vendor
rm -rf ./tests

zip -r $pluginfolder/$foldername-$version.zip ./ > /dev/null

cd ../

rm -rf /tmp/$foldername
cd $pluginfolder

echo "Done!"