#!/bin/sh

# How works
# - Place the index.html on a webserver
# - Place that script in a subfolder like script
# - Place in the script folder the csv file with name, surname and email in column
# - Install cutycapt and imagemagick
# - Improve the crop and size of the certificate based on your own
# - Execute to generate ina subolder output all the pdf ready to sent in an email with the name of the person

cp ../index.html ../index-backup.html

while IFS=, read name surname email
do
    # Trim space
    name=$(printf '%s' "$name" | sed 's/ *$//g')
    surname=$(printf '%s' "$surname" | sed 's/ *$//g')
    # Uppercase first letter
    name=$(printf '%s' "$name" | sed 's/\(.\)/\U\1/')
    surname=$(printf '%s' "$surname" | sed 's/\(.\)/\U\1/')
    echo "Processing $name $surname"

    sed -i "s/{nome_persona}/$name $surname/g" ../index.html
    sed -i "s/{nome_organizzatore}/Giovanni La Motta/g" ../index.html
    name="$name $surname"
    cutycapt --url=http://localhost/certificato/ --out="./output/cert-$name.png" --min-width=1200 --min-height=780
    mogrify -crop 1160x778+0+0 "./output/cert-$name.png"
    convert "./output/cert-$name.png" -quality 100 -units PixelsPerInch -density 200 -resize 2239x1554 -extent 2239x1500x "./output/output-$name.pdf"
    
    rm "./output/cert-$name.png"
    cp ../index-backup.html ../index.html

done < TBTW.csv
