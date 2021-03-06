#!/usr/bin/python3
import argparse
import os
import lxml.html
import sys
import re
from urllib.request import urlopen, Request

parser = argparse.ArgumentParser(description='Generate titles by links list')
parser.add_argument('-source', dest='source', required=True, type=str)
parser.add_argument('-mode', dest='mode', type=str)
args = parser.parse_args()

newfile = []
regex = re.compile(
    r'^(?:http|ftp)s?://'  # http:// or https://
    r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|'  # domain...
    r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'  # ...or ip
    r'(?::\d+)?'  # optional port
    r'(?:/?|[/?]\S+)$', re.IGNORECASE)

if os.path.exists(args.source):
    for line in open(args.source, 'r'):
        if line.startswith('*'):
            url = line[1:].strip()
            try:
                if re.match(regex, url):
                    print('Processing', url)
                    t = lxml.html.parse(urlopen(Request(url, headers={'User-Agent': 'Mozilla'})))
                    title = t.find(".//title").text
                    link = title.strip().replace('  ', ' ') + ' - ' + line
                    if args.mode == 'md':
                        line = '* [' + title + '](' + url + ")\n"
                    else:
                        line = '* ' + title + ' - ' + url + "\n"
            except:
                print('Error:', url)
        newfile.append(line)
else:
    print('Error: The file doesn\'t exists')
    sys.exit()

with open(args.source, "w") as f:
    for item in newfile:
        f.write("%s" % item)
