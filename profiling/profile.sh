#!/bin/bash

echo "Loop of curl request for the page $1"

for i in {1..20}
do
    curl -so /dev/null -H "Pragma: no-cache" -w "%{time_total}\n" $1 | sed 's/\,/./'
done | awk '{ sum +=$1; n++; print $1 } END { if (n > 0) print "AVG: " sum / n; }'
