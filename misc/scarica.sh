#!/bin/bash
ago=$(date +"%Y%m%d" -d "last-monday - 2 week")
cd /media/disk3part1/Musica/Da_Vedere/scaricati/
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/FunkyyPanda/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600"
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/NewRetroWave/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600"
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/MonstercatMedia/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600"
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/UCLFlh_qSWmdPkMLaI2YUxTg/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600" # Electro swing elite
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCtIOyeupgM3jRAn74Q1RNeQ/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600" --dateafter $ago # Stefano di carlo
timeout 2m youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCr_D8RsfDhZ1CVgD7l5ByoQ/featured --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --match-filter "duration < 600" --dateafter $ago # immortal swing
