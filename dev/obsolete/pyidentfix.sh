#!/bin/bash

#fix identation

#check condition
/usr/share/doc/python2.7/examples/Tools/scripts/pindent.py -c $1
#fix identation
/usr/share/doc/python2.7/examples/Tools/scripts/pindent.py -r $1
#remove comment used for identation
/usr/share/doc/python2.7/examples/Tools/scripts/pindent.py -d $1

#convert to space
sed -i.bak -e 's/    /\t/g' $1