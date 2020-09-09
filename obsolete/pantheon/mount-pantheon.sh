#!/bin/bash

# Required sshfs on your system
# Example: mount-pantheon.sh host user sitename
# Is the same of: terminus site mount --site=site-name --destination=/tmp/folder --env=dev
# Folder mount on /tmp, change with your path

host=$1
user=$2
name=$3
path=/tmp/"$name"

if [ -z $host ] && [ -z $user ] &&  [ -z $name ]; then
    echo ''
    echo 'This script require 3 parameter in that order: host, user and name (this last is used for the folder name)'
    echo 'Made by Mte90 for Codeat'
    exit
fi

if ! [ -x "$(command -v sshfs)" ]; then
  echo 'sshfs is missing on that system' >&2
  exit
fi

if [ -z $host ]; then
    echo -e "\033[1mMissing the host parameter\033[0m"
    exit
fi

if [ -z $user ]; then
    echo -e "\033[1mMissing the user parameter\033[0m"
    exit
fi

if [ -z $name ]; then
    echo -e "\033[1mMissing the name parameter\033[0m"
    exit
fi

if [ ! -d $path ]; then
    mkdir $path
else
    echo -e "\033[1mThe folder on $path already exist, change name or remove that folder\033[0m"
    exit
fi

echo 'Wait a moment, mounting can require few seconds'
sshfs -p 2222 "$user"@"$host": $path -o follow_symlinks

echo "$name mounted successful"
echo "To unmount use 'umount $path'"
