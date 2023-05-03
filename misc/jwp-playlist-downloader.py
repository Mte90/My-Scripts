#!/usr/bin/env python3
import requests
import json
from os.path import exists
from os import makedirs
from datetime import datetime

playlists = [""] # insert ids


def download_subplaylist(json, total):
    if "next" in json["links"]:
        print("new page", json["links"]["next"])
        resp = requests.get(json["links"]["next"])
        new_json = resp.json()
        total += new_json["playlist"]
        if "next" in new_json["links"]:
            json, total = download_subplaylist(new_json, total)
    return json, total


print("Started", datetime.now())
print("Playlist downloading/check")
if not exists("playlist/"):
    makedirs("playlist/")

for playlist in playlists:
    if not exists("playlist/" + playlist + ".json"):
        print(playlist + " in progress")
        resp = requests.get("https://cdn.jwplayer.com/v2/playlists/" + playlist + "?format=json")
        resp = resp.json()
        _output, to_save = download_subplaylist(resp, resp["playlist"])

        output = open("playlist/" + playlist + ".json", "w")
        json.dump(to_save, output, indent=4)
        output.close()

if not exists("playlist.json"):
    _new_playlist = []
    print("playlist merge")
    for playlist in playlists:
        _file = open("playlist/" + playlist + ".json", "r+")
        file_data = json.load(_file)
        _file.close()
        _new_playlist += file_data

    new_playlist = {}
    for item in _new_playlist:
        if "jwpseg" in item:
            item.pop("jwpseg")
        if "jwpseg_client_side" in item:
            item.pop("jwpseg_client_side")
        if "tags" in item:
            item.pop("tags")
        item.pop("images")
        item.pop("tracks")
        item.pop("variations")
        item.pop("link")
        item.pop("image")
        item.pop("description")
        new_playlist[item["mediaid"]] = item

    with open("playlist.json", "w") as outfile:
        json.dump(new_playlist, outfile, indent=4)

if not exists("videos/"):
    makedirs("videos/")

with open("playlist.json") as json_data:
    videos = json.load(json_data)

    for video in videos:
        date = datetime.fromtimestamp(video["pubdate"]).strftime("%Y%m%d")
        path = "videos/" + date + "_" + video["mediaid"] + "_" + video["title"].replace("/", "") + ".mp4"
        path = path.replace(",", "").replace("'", "")
        pos = -1
        if not exists(path):
            source = video["sources"]
            if source[pos]['type'] != "video/mp4":
                pos = pos - 1
            size = (int(source[pos]["filesize"]) / 1000) / 1000
            print("downloading " + video["mediaid"] + ", size:" + str(size))
            last_video = source[pos]["file"]
            r = requests.get(last_video, stream=True)
            with open(path, "wb") as f:
                for ch in r:
                    f.write(ch)
            # download video in lower resolution if > 150mb
            if size > 150:
                print("downloading low " + video["mediaid"])
                if source[pos]['type'] != "video/mp4":
                    pos = pos - 1
                last_video = source[pos - 1]["file"]
                r = requests.get(last_video, stream=True)
                with open(path.replace(".mp4", "_low.mp4"), "wb") as f:
                    for ch in r:
                        f.write(ch)

print("Finish", datetime.now())
