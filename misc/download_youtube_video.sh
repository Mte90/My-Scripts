#!/bin/bash
ago=$(date +"%Y%m%d" -d "last-monday - 2 week")
dir=$(mktemp -d)
cd "$dir"
echo "$dir"
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCtIOyeupgM3jRAn74Q1RNeQ/featured --max-download 1 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --dateafter "$ago" --lazy-playlist # Stefano di carlo
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/FunkyyPanda/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --lazy-playlist
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/NewRetroWave/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --lazy-playlist
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/MonstercatMedia/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --lazy-playlist
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/user/UCLFlh_qSWmdPkMLaI2YUxTg/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --lazy-playlist # Electro swing elite
youtube-dl --extract-audio --audio-format=mp3 -w -c https://www.youtube.com/channel/UCr_D8RsfDhZ1CVgD7l5ByoQ/featured --max-download 3 -o "%(title)s.%(ext)s" --match-filter "duration > 100 & duration < 600" --dateafter "$ago" --lazy-playlist # immortal swing

rename 's/\ Visualizer\ //g' ./*
rename 's/\#basshouse//g' ./*
rename 's/\#complextro//g' ./*
rename 's/\#dance//g' ./*
rename 's/\#deephouse//g' ./*
rename 's/\#discohouse//g' ./*
rename 's/\#DiscoHouse//g' ./*
rename 's/\#edm//g' ./*
rename 's/\#electrohouse//g' ./*
rename 's/\#electronic//g' ./*
rename 's/\#electroswing//g' ./*
rename 's/\#electrohouse//g' ./*
rename 's/\#electronic//g' ./*
rename 's/\#electroswing//g' ./*
rename 's/\#ElectroSwing//g' ./*
rename 's/\#frenchtouch//g' ./*
rename 's/\#futurefunk//g' ./*
rename 's/\#FutureFunk//g' ./*
rename 's/\#Futurefunk//g' ./*
rename 's/\#futurebass//g' ./*
rename 's/\#funky//g' ./*
rename 's/\#funk//g' ./*
rename 's/\#glitchhop//g' ./*
rename 's/\#indiedance//g' ./*
rename 's/\#indie//g' ./*
rename 's/\#italodisco//g' ./*
rename 's/\#jpop//g' ./*
rename 's/\#music//g' ./*
rename 's/\#nudisco//g' ./*
rename 's/\#NuDisco//g' ./*
rename 's/\#retrowave//g' ./*
rename 's/\#Retrowave//g' ./*
rename 's/\#soulhouse//g' ./*
rename 's/\#swing//g' ./*
rename 's/\#synthwave//g' ./*
rename 's/\#synthpop//g' ./*
rename 's/\#techhouse//g' ./*
rename 's/\[Dubstep\]//g' ./*
rename 's/\[Electronic]//g' ./*
rename 's/\[Electro\]//g' ./*
rename 's/\[Funkyway Release\]//g' ./*
rename 's/\[Funky way Release\]//g' ./*
rename 's/\[House\]//g' ./*
rename 's/\[Lyric Video\]//g' ./*
rename 's/\[Monstercat Release\]//g' ./*
rename 's/\[Monstercat Lyric Video\]//g' ./*
rename 's/\[Monstercat EP Release\]//g' ./*
rename 's/\[Monstercat Official Music Video\]//g' ./*
rename 's/\[Monstercat Release\]//g' ./*
rename 's/\[Official Video\]//g' ./*
rename 's/\[Silk Music\]//g' ./*
rename 's/\(Electro Swing\)//g' ./*
rename 's/\(Future Swing\)//g' ./*
rename 's/\(Jazzy Electro Swing\)//g' ./*
rename 's/\(Official Video\)//g' ./*
rename 's/\(Official Music Video\)//g' ./*
rename 's/Disco Funk//g' ./*
rename 's/Electro House//g' ./*
rename 's/Electro Pop//g' ./*
rename 's/ElectroPop//g' ./*
rename 's/Electro Swing//g' ./*
rename 's/Future Funk//g' ./*
rename 's/Future BASS//g' ./*
rename 's/FutureBASS//g' ./*
rename 's/French ELECTRO//g' ./*
rename 's/Future HOUSE//g' ./*
rename 's/FrenchELECTRO//g' ./*
rename 's/FutureHOUSE//g' ./*
rename 's/Hip Hop//g' ./*
rename 's/NuDISCO//g' ./*
rename 's/Nu Funk//g' ./*
rename 's/Nu Disco//g' ./*
rename 's/Synthwave//g' ./*

rename 's/ _ //g' ./*
rename 's/ \| //g' ./*
rename 's/｜//g' ./*
rename 's/＂//g' ./*


rename 's/_//g' ./*
rename 's/  //g' ./*
rename 's/ \.mp3/\.mp3/g' ./*
