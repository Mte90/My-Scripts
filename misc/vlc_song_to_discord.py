#!/usr/bin/python3

# Delete the file running on VLC

import dbus
import time
from pypresence import Presence

session_bus = dbus.SessionBus()
RPC = Presence('410664151334256663', pipe=0)  # Initialize the client class
RPC.connect()  # Start the handshake loop

while True:
    try:
        player = session_bus.get_object('org.mpris.MediaPlayer2.vlc', '/org/mpris/MediaPlayer2')
        interface = dbus.Interface(player, dbus_interface='org.mpris.MediaPlayer2.Player')
        metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata', dbus_interface='org.freedesktop.DBus.Properties')
        print('VLC identified')
        RPC.update(state=str(metadata['xesam:title']), details=str(metadata['xesam:artist'][0]))
    except:
        RPC.clear()
    time.sleep(15)
