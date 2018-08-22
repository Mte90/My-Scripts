#!/bin/bash

/usr/bin/yakuake &
sleep 1

function instruct {
    cmd="qdbus org.kde.yakuake $1"
    eval $cmd &> /dev/null
    sleep 0.1
}
instruct "/yakuake/sessions org.kde.yakuake.addSession"
instruct "/yakuake/sessions org.kde.yakuake.addSession"
instruct "/yakuake/sessions org.kde.yakuake.addSession"

instruct "/yakuake/tabs org.kde.yakuake.setTabTitle 0 root"
instruct "/yakuake/tabs org.kde.yakuake.setTabTitle 1 VVV"
instruct "/yakuake/tabs org.kde.yakuake.setTabTitle 2 casa"

# seems that id on that command is switched
instruct "/Sessions/1 org.kde.konsole.Session.sendText \$'su'"
instruct "/Sessions/1 org.kde.konsole.Session.sendText \$'\n'"
instruct "/Sessions/1 org.kde.konsole.Session.sendText $1"
instruct "/Sessions/1 org.kde.konsole.Session.sendText \$'\n'"

instruct "/yakuake/sessions org.kde.yakuake.runCommandInTerminal 1 'vvv'"
instruct "/yakuake/sessions org.kde.yakuake.runCommandInTerminal 2 'casa'"
instruct "/yakuake/sessions org.kde.yakuake.runCommandInTerminal 1 'clear'"
instruct "/yakuake/sessions org.kde.yakuake.runCommandInTerminal 2 'clear'"

instruct "/yakuake/sessions org.kde.yakuake.removeSession 3"
