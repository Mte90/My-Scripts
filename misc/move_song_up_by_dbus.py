#!/usr/bin/python3

# Delete the file running on VLC

import dbus, os
from urllib.parse import unquote

def has_numbers(inputString):
    return any(char.isdigit() for char in inputString)

session_bus = dbus.SessionBus()

player = session_bus.get_object('org.mpris.MediaPlayer2.vlc', '/org/mpris/MediaPlayer2')
interface = dbus.Interface(player, dbus_interface='org.mpris.MediaPlayer2.Player')
metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata', dbus_interface='org.freedesktop.DBus.Properties')

path  = unquote(metadata['xesam:url']).replace('file://','')

if ".mp3" in path or ".m4a" in path or ".ogg" in path or ".flac" in path:
    folder = os.path.abspath(os.path.join(path, os.pardir)) + '/'
    folder = os.path.abspath(os.path.join(folder, os.pardir)) + '/'
    first_parent = folder + os.path.basename(path)
    os.rename(path, first_parent)
    # If is an album folder of a discography move up * 2
    if has_numbers(os.path.basename(os.path.dirname(path))[0:4]):
        folder = os.path.abspath(os.path.join(folder, os.pardir)) + '/'
        os.rename(first_parent, folder + os.path.basename(path))


interface.Next()
