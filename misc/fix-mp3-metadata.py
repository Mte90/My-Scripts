#!/usr/bin/env python3
# Fix MP3 metadata using the filename if they are missing

import os
import eyed3
import sys


def process_mp3_files(directory):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.lower().endswith(".mp3"):
                filepath = os.path.join(root, file)
                parts = file.split(" - ", 1)

                if len(parts) == 2:
                    artist, title = parts
                    # Check if the artist part starts with a number
                    if artist.strip().isdigit():
                        continue
                    title = title.rsplit('.', 1)[0]
                    if len(title) > 0:
                        update_mp3_metadata(filepath, artist, title)

def update_mp3_metadata(filepath, artist, title):
    sys.stdout = open(os.devnull, 'w')
    sys.stderr = open(os.devnull, 'w')
    audiofile = eyed3.load(filepath)
    sys.stdout = sys.__stdout__
    sys.stderr = sys.__stderr__

    if audiofile is None:
        print(f"Skipping invalid MP3 file: {filepath}")
        return

    if not audiofile.tag:
        audiofile.initTag()

    updated = False
    if not audiofile.tag.artist:
        audiofile.tag.artist = artist
        updated = True
    if not audiofile.tag.title:
        audiofile.tag.title = title
        updated = True

    if updated:
        try:
            sys.stdout = open(os.devnull, 'w')
            sys.stderr = open(os.devnull, 'w')
            audiofile.tag.save()
            sys.stdout = sys.__stdout__
            sys.stderr = sys.__stderr__
            print(f"Updated: {filepath} -> Artist: '{artist}', Title: '{title}'")
        except:
            print(f"File not saved for issues: {filepath}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: fix-mp3-metadata.py <directory>")
        sys.exit(1)

    folder_path = sys.argv[1]
    if os.path.isdir(folder_path):
        process_mp3_files(folder_path)
    else:
        print("Invalid directory path!")
        sys.exit(1)
