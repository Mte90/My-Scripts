#!/usr/bin/env bash
# Kill any process if the memory used is over the limit

LIMIT=$((6 * 1024 * 1024)) # in KB

while true; do
    ps -eo pid,rss,comm --no-headers | while read pid rss comm; do
        if [ "$rss" -gt "$LIMIT" ]; then
            echo "Killing $comm (PID $pid) using ${rss}KB RAM"
            kill -9 $pid
        fi
    done
    sleep 10
done
