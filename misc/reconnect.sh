#!/usr/bin/env bash

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  echo "IPv4 is up"
else
  sleep 15m
  sudo shutdown -h now
fi 
