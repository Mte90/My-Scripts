#!/usr/bin/python3
import csv
import sys
import os
from urllib.parse import urlsplit  # Python 3

if os.path.isfile(sys.argv[1]):
    with open(sys.argv[1], newline='') as csvfile:
         url = csv.reader(csvfile, delimiter=',', quotechar='|')
         for row in url:
             old = urlsplit(row[0].replace('"', ''))
             new = urlsplit(row[1].replace('"', ''))
             print('RewriteRule ^' + old.path[1:] + '$ ' + new.path + ' [R=301,L]')
