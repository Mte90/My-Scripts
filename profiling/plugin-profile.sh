#!/bin/bash

echo "Loop of curl request, with plugin disabled for the page $1"

for p in $(wp plugin list --fields=name --status=active)
do
echo "Plugin: $p"
    for i in {1..5}
    do
        curl -so /dev/null -H "Pragma: no-cache" -w "%{time_total}\n" $1 | sed 's/\,/./'
    done | awk '{ sum +=$1; n++; print $1 } END { if (n > 0) print "AVG: " sum / n; }'
    wp plugin activate $p
done
