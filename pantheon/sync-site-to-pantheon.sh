#!/bin/bash

# Required sshfs, curlftps, rsync on your system
# Example: sync-site-to-pantheon.sh
# Folder mount on /tmp, change with your path

ph_host=
ph_user=
ph_name=
ph_path=/tmp/"$ph_name"

site_host=
site_user=
site_pass=
site_name=
site_path=/tmp/"$site_name"
site_folder=/public_html

if [ -z $ph_host ] && [ -z $ph_user ] &&  [ -z $ph_name ]; then
    echo ''
    echo 'This script require to set the hardcoded parameter'
    echo 'Made by Mte90 for Codeat'
    exit
fi

if ! [ -x "$(command -v sshfs)" ]; then
  echo 'sshfs is missing on that system' >&2
  exit
fi

if ! [ -x "$(command -v curlftpfs)" ]; then
  echo 'curlftpfs is missing on that system' >&2
  exit
fi

if [ ! -d $ph_path ]; then
    mkdir $ph_path
else
    echo -e "\033[1mThe folder on $ph_path already exist, change name or remove that folder\033[0m"
    exit
fi

if [ ! -d $site_path ]; then
    mkdir $site_path
    #Set correct permission to access at the folder
    chgrp fuse $site_path
    chmod g+w $site_path
    site_path_folder=$site_path$site_folder
else
    echo -e "\033[1mThe folder on $site_path already exist, change name or remove that folder\033[0m"
    exit
fi

echo 'Wait a moment, mounting can require few seconds'

sshfs -p 2222 "$ph_user"@"$ph_host": $ph_path -o follow_symlinks
echo 'Pantheon site mounted!'

curlftpfs -o allow_other,ro "$site_user":"$site_pass"@"$site_host" $site_path
echo 'FTP site mounted!'

echo "To unmount use 'umount $ph_path && umount $site_path'"
echo ""

echo 'Start sync files from Site to Pantheon'
# add --delete flag to remove file that not exist in site but exist in pantheon
if [ -d $site_path_folder/wp-content ]; then
    rsync -av $site_path_folder/wp-content $ph_path/code --exclude 'wp-config.php'
    rsync -av $site_path_folder/wp-admin $ph_path/code --exclude 'wp-config.php'
    rsync -av $site_path_folder/wp-includes $ph_path/code --exclude 'wp-config.php'
fi