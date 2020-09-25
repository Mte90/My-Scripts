#!/usr/bin/python3
import csv
import sys
import os

if os.path.isfile(sys.argv[1]):
    with open(sys.argv[1], newline='') as csvfile:
         url = csv.reader(csvfile, delimiter=',', quotechar='|')
         for row in url:
             print('Redirect 301 ' + row[0].replace('"', '') + ' https://' + sys.argv[2])
