#!/usr/bin/python3
import argparse
import os
import lxml.html
from urllib.request import urlopen

parser = argparse.ArgumentParser(description='Generate titles of pages by links list')
parser.add_argument('-source', dest='source', required=True, type=str)
args = parser.parse_args()

lists = []
md_lists = []

if os.path.exists(args.source):
    for line in open(args.source, 'r'):
        t = lxml.html.parse(urlopen(line.strip()))
        title = t.find(".//title").text
        link = title + ' - ' + line
        md_link = '* [' + title + '](' + line + ')'
        lists.append(link)
        md_lists.append(md_link)

with open('/tmp/parsed.txt', "w") as f:
    for item in lists:
        f.write("%s" % item)
        
with open('/tmp/parsed.md', "w") as f:
    for item in md_lists:
        f.write("%s" % item)
