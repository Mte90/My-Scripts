#!/usr/bin/python3
import argparse
import os
import lxml.html
from urllib.request import urlopen

parser = argparse.ArgumentParser(description='Generate titles of pages by links list')
parser.add_argument('-source', dest='source', required=True, type=str)
args = parser.parse_args()

lists = []

if os.path.exists(args.source):
    for line in open(args.source, 'r'):
        t = lxml.html.parse(urlopen(line.strip()))
        title = t.find(".//title").text
        title = title.split("(")[1]
        title = title.split(")")[0]
        link = title + ' - ' + line
        lists.append(link)
        print(link)

with open('/tmp/parsed.txt', "w") as f:
    for item in lists:
        f.write("%s" % item)
