#!/usr/bin/env python3
import argparse
import json
import os
import urllib.request
import urllib.parse

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


def download_image(folder, console, game):
    repo = "https://raw.githubusercontent.com/libretro-thumbnails/" + console + "/master/"
    print(' Downloaded ' + game + ' thumbnails')
    original_game = game + '.png'
    game = urllib.parse.quote(game + '.png')
    try:
        urllib.request.urlretrieve(repo + 'Named_Boxarts/' + game, folder + '/Named_Boxarts/' + original_game)
    except:
        pass
    try:
        urllib.request.urlretrieve(repo + 'Named_Snaps/' + game, folder + '/Named_Snaps/' + original_game)
    except:
        pass
    try:
        urllib.request.urlretrieve(repo + 'Named_Titles/' + game, folder + '/Named_Titles/' + original_game)
    except:
        pass


console = get_console_name(args.playlist)
folder = create_folders(os.path.splitext(os.path.basename(args.playlist))[0])
print('Downloading ' + console + ' thumbnails')
with open(args.playlist, "r") as read_file:
    data = json.load(read_file)
    if len(data['items']) > 0:
        for item in data['items']:
            download_image(folder, console, item['label'])
    else:
        print('Empty playlist.')
        exit
