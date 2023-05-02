#!/usr/bin/env bash

ffmpeg -i $1 -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-28dB pulito-$1
