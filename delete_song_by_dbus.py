#!/usr/bin/python3.5

# Delete the file running on VLC

import dbus, os

session_bus = dbus.SessionBus()

player = session_bus.get_object('org.mpris.MediaPlayer2.vlc', '/org/mpris/MediaPlayer2')
interface = dbus.Interface(player, dbus_interface='org.mpris.MediaPlayer2.Player')
metadata = player.Get('org.mpris.MediaPlayer2.Player', 'Metadata', dbus_interface='org.freedesktop.DBus.Properties')

os.remove(metadata['xesam:url'].replace('%23','#').replace('%28','(').replace('%5B','[').replace('%5D',']').replace('%2C',',').replace('%29',')').replace('%27',"'").replace('%26','&').replace('%20',' ').replace('file://',''))

interface.Next()
