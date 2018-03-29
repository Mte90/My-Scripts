#!/bin/bash

if (exec 3<>/dev/tcp/192.168.1.10/22) 2> /dev/null; then
    sshfs -o password_stdin root@192.168.1.10:/var/www /mnt/dandoo <<< "dandoo"
    cd /mnt/dandoo
    echo "Mounted"
fi
