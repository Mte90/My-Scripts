#!/bin/bash
#
# Script for downlaod by git and compile and install by kde repo
#
# Instructions on how to use the script :
#     -b    build only (updates repos before build)
#     -bi   build and install (updates repos before build)
#     -u    update/clone repos
#     -h    show help menu
#
# Copyright (C) 2011 Rohan Garg <rohan16garg@gmail.com>
# Copyright (C) 2011 Dominik Schmidt <dev@dominik-schmidt.de>
# Copyright (C) 2011 Francesco Nwokeka <francesco.nwokeka@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###############################################################################

SOURCE_DIR="."

REPOS="
klook
akonadi-social-utils
akonadi-facebook
homerun
libkgapi
plasmate
print-manager
web-accounts
plasmoid-eventlist
rekonq
kio-mtp"

# configure your own custom build function here
function build {
    for repo in $REPOS
    do
        cd $repo

        echo ""
        echo "####################################################"
        echo "              Building $repo               "
        echo "####################################################"

        if [ $NEONENV ]; then
            neonmake
        else
            mkdir -p build
            cd build

                cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=debugfull ..

            make -j16
            cd ..
        fi
        cd ..
    done
}

function buildInstall {
    build

    for repo in $REPOS
    do
	echo ""
        echo "####################################################"
        echo "              Installing $repo           	    "
        echo "####################################################"
        cd $repo/build
        sudo make install
        cd ../../
    done
}

function updateRepos {
    mkdir -p $SOURCE_DIR
    cd $SOURCE_DIR

    for repo in $REPOS
    do
        if [ -d "$repo" ]; then
            cd $repo
            echo ""
            echo "####################################################"
            echo "               Updating $repo              "
            echo "####################################################"

            git pull
            cd ..
        else
            echo ""
            echo "####################################################"
            echo "               Cloning $repo              "
            echo "####################################################"

                git clone git://anongit.kde.org/$repo
        fi
    done
}

function showHelp {
    echo "-b    build only (updates repos before build)"
    echo "-bi   build and install (updates repos before build)"
    echo "-u    update/clone repos"
    echo "-h    show this help menu"
}


if [ "$?" = "0" ];
    then
        if [ "$1" = "-b" ];
        then
            updateRepos
            build

        elif [ "$1" = "-bi" ];
        then
            updateRepos
            buildInstall

        elif [ "$1" = "-u" ];
        then
            updateRepos

        else [ "$1" = "-h" ];
            showHelp
        fi
fi