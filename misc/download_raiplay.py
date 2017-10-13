#!/usr/bin/python3

# First parameter is the page like: http://www.raiplay.it/programmi/cameracafe/
# Second parameter where download the file
# If the file is already available is not downloaded

import lxml.html, sys, os
from lxml.cssselect import CSSSelector
from urllib.request import urlopen
import youtube_dl

os.chdir(sys.argv[2])
html = urlopen(sys.argv[1]).read().decode('utf-8')
tree = lxml.html.fromstring(html)
sel = CSSSelector('a.video, .puntateItem a')
results = sel(tree)

for link in results:
    link = 'http://www.raiplay.it' + link.get('href')

    with youtube_dl.YoutubeDL({'nooverwrites': True, 'forcetitle': True}) as ydl:
        ydl.download([link])
