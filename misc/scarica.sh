#!/bin/bash
ago=$(date +"%Y%m%d" -d "last-monday - 2 week")
cd /tmp/
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/FunkyyPanda/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600"
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/NewRetroWave/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600"
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/MonstercatMedia/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600"
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/UCLFlh_qSWmdPkMLaI2YUxTg/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600" # Electro swing elite
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCtIOyeupgM3jRAn74Q1RNeQ/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600" --dateafter $ago # Stefano di carlo
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCr_D8RsfDhZ1CVgD7l5ByoQ/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration < 600" --dateafter $ago # immortal swing

rename 's/\#complextro//g' ./*
rename 's/\#deephouse//g' ./*
rename 's/\#discohouse//g' ./*
rename 's/\#edm//g' ./*
rename 's/\#electrohouse//g' ./*
rename 's/\#electronic//g' ./*
rename 's/\#electroswing//g' ./*
rename 's/\#frenchtouch//g' ./*
rename 's/\#glitchhop//g' ./*
rename 's/\#indie//g' ./*
rename 's/\#italodisco//g' ./*
rename 's/\#jpop//g' ./*
rename 's/\#retrowave//g' ./*
rename 's/\#synthwave//g' ./*
rename 's/\#nudisco//g' ./*

rename 's/ _ //g' ./*
