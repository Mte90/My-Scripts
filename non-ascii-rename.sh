#!/bin/sh

find . -exec rename 's/[^\x00-\x7F]//g' "{}" \;
