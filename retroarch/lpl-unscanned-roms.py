#!/usr/bin/env python3
import argparse
import json
import os
import sys
import glob

parser = argparse.ArgumentParser(description='Scan a thumbnail from a .lpl')
parser.add_argument('--playlist', help='Playlist file', nargs='?', action='store', const='', default='')
parser.add_argument('--remap', help='Path of the USB stick in the computer where is running the script', nargs='?', action='store', const='', default='/media/')
args = parser.parse_args()

if not os.path.exists(args.playlist):
    print(args.playlist + ' doesn\'t exists.')
    sys.exit(1)


def get_console_name(console):
    console = os.path.splitext(os.path.basename(console))[0]
    if 'MAME' in console:
        return 'MAME'
    return console


def merge_mame_playlist(playlist):
    result = []
    path = os.path.dirname(os.path.abspath(playlist))
    for f in glob.glob(path + "/MAME*.lpl"):
        with open(f, "rb") as infile:
            only_games = json.load(infile)
            result = only_games['items'] + result

    with open("/tmp/merged_file.json", "w") as outfile:
        json.dump({'items': result}, outfile)

    return "/tmp/merged_file.json"


console = get_console_name(args.playlist)
playlist = args.playlist
if console == 'MAME':
    playlist = merge_mame_playlist(args.playlist)
roms = {}

print('Scanning ' + console + ' roms')
with open(playlist, "r") as read_file:
    data = json.load(read_file)
    if len(data['items']) > 0:
        for item in data['items']:
            path = item['path'].replace('/media/', args.remap).split('#')
            roms[path[0]] = True
            rom_folder = os.path.dirname(item['path'].replace('/media/', args.remap))
    else:
        print('Empty playlist.')
        sys.exit()

    print(str(len(roms)) + ' roms in the playlist')

print('Local folder ' + rom_folder)

for r, d, f in os.walk(rom_folder):
    for rom in f:
        rom_name = os.path.basename(rom)
        remap_rom = (r + '/' + rom)
        if remap_rom not in roms:
            print(' ROM not reconized: ' + rom_name)

print('Script finished ')
