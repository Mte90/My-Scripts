#!/usr/bin/python3
import argparse
import os
import lxml.html
import lxml.etree
import sys
import re
from urllib.request import urlopen, Request
from urllib.parse import urlencode, urlparse, urlunparse, parse_qs

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


def generate_link(args, url, title):
    line = ''
    if args.mode == 'md':
        line = '* [' + url + '](' + url + ")\n"
    elif args.mode == 'html':
        line = '* <a href="' + url + '" target="_blank">' + url + "</a>\n"
    else:
        line = '* ' + title + ' - ' + url + "\n"
    return line


utf8_html_parser = lxml.etree.HTMLParser(encoding='utf-8')
if os.path.exists(args.source):
    for line in open(args.source, 'r'):
        if line.startswith('*'):
            url = line[1:].strip()
            try:
                if re.match(regex, url):
                    print('Processing:', url)
                    if url.startswith('https://twitter.com/'):
                        u = urlparse(url)
                        query = parse_qs(u.query, keep_blank_values=True)
                        query.pop('t', None)
                        query.pop('s', None)
                        u = u._replace(query=urlencode(query, True))
                        url = urlunparse(u)
                        line = generate_link(args, url, url)
                        newfile.append(line)
                        continue
                    t = lxml.html.parse(urlopen(Request(url, headers={'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101 Firefox/90.0'})), parser=utf8_html_parser)
                    title = t.find(".//title").text
                    title = title.strip().replace("\n", '').replace("\r", '')
                    link = title.replace("\n", '').replace("\r", '').replace('  ', ' ') + ' - ' + line
                    line = generate_link(args, url, title)
            except Exception as e:
                print('Error:', url)
                print('   ' + str(e))
                line = generate_link(args, url, url)
        newfile.append(line)
else:
    print('Error: The file doesn\'t exists')
    sys.exit()

with open(args.source, "w") as f:
    for item in newfile:
        f.write("%s" % item)
