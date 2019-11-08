#!/usr/bin/python3

# Dependence to install: apt install python3-cssselect python3-lxml youtube-dl

# First parameter is the page like: http://www.raiplay.it/programmi/cameracafe/
# Second parameter where download the file
# If the file is already available is not downloaded

import lxml.html, sys, os
from lxml.cssselect import CSSSelector
from urllib.request import urlopen
import requests
import youtube_dl

os.chdir(sys.argv[2])
html = urlopen(sys.argv[1]).read().decode('utf-8')
tree = lxml.html.fromstring(html)
sel = CSSSelector('rai-episodes')
results = sel(tree)

json_url = 'https://www.raiplay.it/' + results[0].get('base_path')
json_url += '/' + results[0].get('block')
json_url += '/' + results[0].get('set') + '/episodes.json'

# Making the http request
r = requests.get(json_url)

# Transforming the data returned into JSON format
data = r.json()

loop = 0

for season in data['seasons']:
    for episode in season['episodes'][0]['cards']:
        video_page = 'https://www.raiplay.it/video/' + episode['weblink']
        with youtube_dl.YoutubeDL({'nooverwrites': True, 'forcetitle': True, 'quiet': True}) as ydl:
            ydl.download([video_page])
            loop += 1

print("\nDownloaded " + str(loop) + " files")
