#!/usr/bin/env bash

cd /tmp/
mkdir wpcs
cd ./wpcs
wget https://github.com/WordPress/WordPress-Coding-Standards/archive/refs/heads/develop.zip
unzip develop.zip
cd WordPress-Coding-Standards-develop
mv ./WordPress /usr/share/php/PHP/CodeSniffer/src/Standards/WordPress
mv ./WordPress-Core /usr/share/php/PHP/CodeSniffer/src/Standards/WordPress-Core
mv ./WordPress-Extra /usr/share/php/PHP/CodeSniffer/src/Standards/WordPress-Extra
mv ./WordPress-Docs /usr/share/php/PHP/CodeSniffer/src/Standards/WordPress-Docs
