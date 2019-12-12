#!/usr/bin/env python3
import argparse
import json
import os
import sys

parser = argparse.ArgumentParser(description='Scan a thumbnail from a .lpl')
parser.add_argument('--playlist', help='Playlist file', nargs='?', action='store', const='', default='')
parser.add_argument('--remap', help='Path of the USB stick in the computer where is running the script', nargs='?', action='store', const='', default='/media/')
args = parser.parse_args()

if not os.path.exists(args.playlist):
    print(args.playlist + ' doesn\'t exists.')
    exit


def get_console_name(console):
    console = os.path.splitext(os.path.basename(console))[0]
    if 'MAME' in console:
        return 'MAME'
    return console


console = get_console_name(args.playlist)
roms = {}

print('Scanning ' + console + ' roms')
with open(args.playlist, "r") as read_file:
    data = json.load(read_file)
    print(str(len(data['items'])) + ' roms in the playlist')
    if len(data['items']) > 0:
        for item in data['items']:
            path = item['path'].replace('/media/', args.remap).split('#')
            roms[path[0]] = True
            rom_folder = os.path.dirname(item['path'].replace('/media/', args.remap))
    else:
        print('Empty playlist.')
        sys.exit()

print('Local folder ' + rom_folder)

for r, d, f in os.walk(rom_folder):
    for file in f:
        rom_name = os.path.basename(file)
        remap_rom = (r + '/' + file)
        if remap_rom not in roms:
            print(' ROM not reconized: ' + rom_name)
