#!/usr/bin/env python3
import csv
import sys
from urllib.parse import urlparse

source = sys.argv[1]
where = sys.argv[2]
source_list = []
where_list = []

with open(source) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        try:
            url = urlparse(row[0]).path
            source_list.append(url)
        except:
            pass

with open(where) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    for row in csv_reader:
        url = urlparse(row[0]).path
        if url in source_list:
            print(url)
