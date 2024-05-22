#!/usr/bin/env bash
echo $(date)
for ((i = 1; i <= 1300; i++)); do # Set the page where to start and the one to finish
    page=$(wget "https://www.website.com/uncategorized/page/$i" -q -O -)
    sed '1,156d' <<< "$page" > /tmp/clean # Strip the first lines in this way doens't download everything
    links=$(cat /tmp/clean | sed '/\bcategory\b/d' | grep -o 'href=.*\/' | sed 's@href\=@@' | sed 's/\s.*$//' | sed '/^\"/d' | uniq)
    # Get the list of links

    echo "Parsing page $i"
    echo $(date)
    for item in "${links[@]}"; do
        parallel --jobs 6 ::: $(wget -p -k -P "./" $item &> /dev/null)
    done
    wget -p -k -P "./" "https://www.website.com/uncategorized/page/$i" &> /dev/null
done

