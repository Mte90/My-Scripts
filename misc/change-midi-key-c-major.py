#!/usr/bin/env python3

# In Italy C Major is "Do Maggiore"
# With this script is possible to convert a bunch of MIDI
#  to play with Synthesia and have all the diesis etc on the sheet near the note

# Based on http://nickkellyresearch.com/python-script-transpose-midi-files-c-minor/

# Create a empty track that need to be removed manually

import glob
import os
import music21

# major conversions
majors = dict([("A-", 4),("A", 3),("B-", 2),("B", 1),("C", 0),("D-", -1),("D", -2),("E-", -3),("E", -4),("F", -5),("G-", 6),("G", 5)])
minors = dict([("A-", 1),("A", 0),("B-", -1),("B", -2),("C", -3),("D-", -4),("D", -5),("E-", 6),("E", 5),("F", 4),("G-", 3),("G", 2)])

os.chdir("./")
for file in glob.glob("*.mid"):
    print('Parsing ' + file)
    score = music21.converter.parse(file)
    key = score.analyze('key')
    print("Convert", key.tonic.name, key.mode, "To C Major")
    if key.mode == "major":
        halfSteps = majors[key.tonic.name]
        
    elif key.mode == "minor":
        halfSteps = minors[key.tonic.name]
    
    newscore = score.transpose(halfSteps)
    key = newscore.analyze('key')
    newscore.write('midi',file)
