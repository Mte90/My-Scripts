#!/usr/bin/python3

# Delete the file running on VLC

import dbus, os
from urllib.parse import unquote

session_bus = dbus.SessionBus()

player = session_bus.get_object('org.mpris.MediaPlayer2.vlc', '/org/mpris/MediaPlayer2')
interface = dbus.Interface(player, dbus_interface='org.mpris.MediaPlayer2.Player')
metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata', dbus_interface='org.freedesktop.DBus.Properties')

path  = unquote(metadata['xesam:url']).replace('file://','')

if "mp4" not in path or "avi" not in path:
    os.remove(path)

interface.Next()
