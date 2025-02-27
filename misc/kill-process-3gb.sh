#!/usr/bin/env bash
# Kill a process if the memory used is over the limit

PROCESS_NAMES=("pylsp") # array
LIMIT_MB=3072

while true; do
    for PROCESS_NAME in "${PROCESS_NAMES[@]}"; do
        PIDS=$(pgrep "$PROCESS_NAME")
        for PID in $PIDS; do
            MEM_USAGE_KB=$(ps -o rss= -p $PID)
            MEM_USAGE_MB=$((MEM_USAGE_KB / 1024))

            if [[ "$MEM_USAGE_MB" -gt $LIMIT_MB ]]; then
                echo "Process $PROCESS_NAME ($PID) exceeds RAM limit ($MEM_USAGE_MB MB), terminating..."
                kill -9 $PID
            fi
        done
    done
    sleep 10
done
