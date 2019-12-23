#!/usr/bin/env python3
import argparse
import json
import os
import urllib.request
import urllib.parse
import sys
import re

parser = argparse.ArgumentParser(description='Download a thumbnail from a .lpl')
parser.add_argument('--playlist', help='Playlist file', nargs='?', action='store', const='', default='')
args = parser.parse_args()

if not os.path.exists(args.playlist):
    print(args.playlist + ' doesn\'t exists.')
    exit


def create_folders(console):
    if not os.path.exists('./thumbnails/'):
        os.mkdir('./thumbnails/')

    if not os.path.exists('./thumbnails/' + console):
        os.mkdir('./thumbnails/' + console)

    if not os.path.exists('./thumbnails/' + console + '/Named_Boxarts'):
        os.mkdir('./thumbnails/' + console + '/Named_Boxarts')
    if not os.path.exists('./thumbnails/' + console + '/Named_Snaps'):
        os.mkdir('./thumbnails/' + console + '/Named_Snaps')
    if not os.path.exists('./thumbnails/' + console + '/Named_Titles'):
        os.mkdir('./thumbnails/' + console + '/Named_Titles')

    return './thumbnails/' + console


def get_console_name(console):
    console = os.path.splitext(os.path.basename(console))[0]
    if 'MAME' in console:
        return 'MAME'
    return console


def download_image(folder, console, game, retry):
    repo = "https://raw.githubusercontent.com/libretro-thumbnails/" + urllib.parse.quote(console.replace(' ','_')) + "/master/"
    clean_game = game
    original_game = game.replace('/','_').replace(':','_') + '.png'
    game = urllib.parse.quote(game.replace('&','_').replace(':','_').replace('/','_') + '.png')
    thumbnail = 0
    try:
        urllib.request.urlretrieve(repo + 'Named_Boxarts/' + game, folder + '/Named_Boxarts/' + original_game)
        thumbnail += 1
    except:
        pass
    try:
        urllib.request.urlretrieve(repo + 'Named_Snaps/' + game, folder + '/Named_Snaps/' + original_game)
        thumbnail += 1
    except:
        pass
    try:
        urllib.request.urlretrieve(repo + 'Named_Titles/' + game, folder + '/Named_Titles/' + original_game)
        thumbnail += 1
    except:
        pass

    if thumbnail == 0:
        print("Not found " + clean_game + ' at ' + repo + 'Named_Boxarts/' + game)
        # Try with switching stuff inside parenthesis because the game can have different filenames
        if retry is False:
            if ',' in clean_game:
                s = re.findall('\((.*?)\)', clean_game)
                s = s[0].split(', ')
                try_game_name = s[1] + ', ' + s[0].replace(', ', '')
                clean_game = clean_game.replace(s[0] + ', ' + s[1], try_game_name)
                download_image(folder, console, clean_game, True)
                download_image(folder, console, clean_game.replace(',', ''), True)
    else:
        print(' Downloaded ' + clean_game + ' ' + str(thumbnail) + ' thumbnails')


console = get_console_name(args.playlist)
folder = create_folders(console)
print('Downloading ' + console + ' thumbnails')
with open(args.playlist, "r") as read_file:
    data = json.load(read_file)
    if len(data['items']) > 0:
        for item in data['items']:
            download_image(folder, console, item['label'], False)
    else:
        print('Empty playlist.')
        sys.exit()
