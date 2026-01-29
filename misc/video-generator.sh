#!/bin/bash

INPUT_DIR="."
OUTPUT_DIR="output_videos"
mkdir -p "$OUTPUT_DIR"

mp3_files=("$INPUT_DIR"/*.mp3)
total_files=${#mp3_files[@]}
echo "Found $total_files MP3 files."

for ((i=0; i<total_files; i++)); do
    mp3_file="${mp3_files[$i]}"
    filename=$(basename -- "$mp3_file")
    filename_noext="${filename%.*}"
    current=$((i+1))
    echo "Processing file $current of $total_files: $filename"

    rm -f "/tmp/temp_cover.jpg"
    ffmpeg -i "$mp3_file" -an -vcodec copy "/tmp/temp_cover.jpg" &> /dev/null
    if [ ! -f "temp_cover.jpg" ]; then
        echo "Skipping $filename: no cover found."
        continue
    fi
    echo "- Cover generated"

    author=$(echo "${filename_noext%%-*}" | sed "s/'/\\\'/g")
    title=$(echo "${filename_noext#*-}" | sed "s/'/\\\'/g" | sed "s/(/\\\(/g" | sed "s/)/\\\)/g")
    echo "$author" > "/tmp/author.txt"
    echo "$title" > "/tmp/title.txt"

    waves_h=160
    overlay_pos=$((720 - waves_h))
    #[0:a]showfreqs=s=1280x$waves_h:mode=bar:colors=blue:scale=log,format=yuv420p[waves];

    ffmpeg -i "$mp3_file" -i "/tmp/temp_cover.jpg" \
    -filter_complex "
    [1:v]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1[bg];
    [0:a]showwaves=s=1280x$waves_h:mode=cline:colors=white@0.9:scale=lin:rate=18,format=yuva420p[waves];
    color=c=black@0.3:size=1280x$waves_h[shade];
    [bg][shade]overlay=x=0:y=720-$waves_h[tmp1];
    [tmp1][waves]overlay=x=0:y=720-$waves_h[tmp2];
    [tmp2]drawtext=textfile=/tmp/author.txt:fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:fontsize=48:fontcolor=white:x=(w-text_w)/2:y=40:borderw=4:bordercolor=black@0.7[tmp3];
    [tmp3]drawtext=textfile=/tmp/title.txt:fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf:fontsize=52:fontcolor=white:x=(w-text_w)/2:y=100:borderw=4:bordercolor=black@0.7
    " \
    -c:v h264_nvenc -c:a copy -shortest "$OUTPUT_DIR/${filename_noext}.mp4"

    rm -f "/tmp/temp_cover.jpg"
    echo "Video generated for: $filename"
done

echo "All videos have been generated in $OUTPUT_DIR/"
