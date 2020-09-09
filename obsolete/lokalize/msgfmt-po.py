# -*- coding: utf-8 -*-
# Lokalize script to compile and export the po files
# Author: Dimitrios Glentadakis <dglent@free.fr>
# https://bugs.kde.org/show_bug.cgi?id=181145
# License: GPLv3
# Edit by Mte90 (16/6/2015) for add new features:
# - Alert for wrong extension
# - Same path of the po/ts file
# - Better check for existing file

import os
import subprocess
import Editor
import Project


def _init():
    global lang
    global package
    global currentFile
    global fileType
    currentFile = Editor.currentFile()
    fileType = currentFile[-2:]
    if not Editor.isValid() or currentFile == '':
        return
    lang = Project.targetLangCode()
    (path, pofilename) = os.path.split(Editor.currentFile())
    (package, ext) = os.path.splitext(pofilename)
    currentFile = Editor.currentFile()
    if fileType == 'po':
        complilerPresent = cmd_exists('msgfmt')
        if complilerPresent:
            saveSameFolder()
        else:
            os.system('kdialog --sorry \
                "The command <msgfmt> is not available.\nYou need to install the gettext package"')
            return
    # Alert for the wrong extension
    else:
        os.system('kdialog --sorry \
                "This format is not supported"')


def cmd_exists(cmd):
    return subprocess.call("type " + cmd, shell=True, \
        stdout=subprocess.PIPE, stderr=subprocess.PIPE) == 0


def saveSameFolder():
    if fileType == 'po':
        ext = '.mo'
        compiler = 'msgfmt -o'
    binPath = os.path.splitext(currentFile)[0] + ext
    if binPath != '':
        binPath = binPath.rstrip()
        os.system('{0} {1} {2}'.format(compiler, binPath, currentFile))


_init()
