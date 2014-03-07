#!/bin/bash

#Simple script for convert the markdown of the ebook in a pdf, useful for the preview or QA
#Author: Mte90

#Dependence: Pandoc
#apt-get install pandoc nbibtex texlive-latex-base texlive-latex-recommended texlive-latex-extra preview-latex-style dvipng texlive-fonts-recommended lmodern

#Read the Book.txt file
#Merge all the content in a big file

while read line; do
cat $line >> ./tmp.md
done < ./Book.txt

#Create PDF

pandoc -o ./Book.pdf ./tmp.md

rm ./tmp.md