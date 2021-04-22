#!/bin/bash
ago=$(date +"%Y%m%d" -d "last-monday - 2 week")
cd /media/disk3part1/Musica/Da_Vedere/scaricati/
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/FunkyyPanda --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --dateafter $ago
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/NewRetroWave --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --dateafter $ago
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/MonstercatMedia --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --dateafter $ago
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/UCLFlh_qSWmdPkMLaI2YUxTg/ --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --dateafter $ago # Electro swing elite
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCtIOyeupgM3jRAn74Q1RNeQ/ --max-download 3 -o "%(title)s-%(id)s.%(ext)s" --dateafter $ago # Stefano di carlo
