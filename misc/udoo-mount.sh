#!/bin/bash
shopt -s extglob

if (exec 3<>/dev/tcp/192.168.1.10/22) 2> /dev/null; then
    sshfs -o password_stdin root@192.168.1.10:/var/www /mnt/dandoo <<< "dandoo"
    echo "Mounted"
    # support for Exakat
    sshpass -p "dandoo" rsync -avz --exclude '*vendor*' --exclude '.padawan' /var/www/VVV/www/glossary/htdocs/wp-content/plugins/glossary/ root@192.168.1.10:/var/exakat/projects/glossary/code/
fi
