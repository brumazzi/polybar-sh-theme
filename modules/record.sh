#!/bin/bash

TMP_PID=/tmp/i3-record-pid.tmp

if [ -f $TMP_PID ]; then
    pid=$(cat $TMP_PID)
    [[ "$pid" -eq 1 ]] && exit 0
fi

REC_STATUS_FILE=/tmp/i3-record-status.tmp
printf 0 > $REC_STATUS_FILE
printf 1 > $TMP_PID

FFMPEG_PID=""

while [ "1" ]; do
    [[ -f $TMP_PID ]] || exit 0
    [[ "$(cat $REC_STATUS_FILE)" -ne 1 ]] && [[ "$FFMPEG_PID" ]] && kill -2 $FFMPEG_PID && echo 0 > $REC_STATUS_FILE
    [[ "$(cat $REC_STATUS_FILE)" -ne 1 ]] && FFMPEG_PID="" && sleep 0.5 && continue
    [[ "$FFMPEG_PID" ]] && sleep 0.5 && continue

    dir_path=$(zenity --file-selection --directory)
    video_data=$(zenity --forms --text="Record" --add-entry="File name"  --add-entry="Frame rate" --add-entry="Video Size (1366x768)")
    # --add-combo="Video encoder" --combo-values "apng|flv|lib264|mpeg4|libwebp" --add-combo="Audio encoder" --combo-values "aac|libmp3lame|vorbis"

    name=$(echo $video_data | awk -F'|' '{ print $1 }')
    rate=$(echo $video_data | awk -F'|' '{ print $2 }')
    size=$(echo $video_data | awk -F'|' '{ print $3 }')
    # video_e=$(echo $video_data | awk -F'|' '{ print $4 }')
    # audio_e=$(echo $video_data | awk -F'|' '{ print $5 }')

    [[ "$size" ]] || size="1366x768"
    [[ "$rate" ]] || rate="30"
    [[ "$audio_e" ]] || audio_e="libmp3lame"
    [[ "$audio_e" == " " ]] && audio_e="libmp3lame"
    [[ "$video_e" ]] || video_e="libx264"
    [[ "$video_e" == " " ]] && video_e="mpeg4"
    [[ "$name" ]] || name="output.mp4"

    [[ -f $dir_path/$name ]] && rm $dir_path/$name

    ffmpeg -video_size $size -framerate $rate -f x11grab -i :1.0 \
           -f alsa -i default \
           -codec:v $video_e -codec:a $audio_e \
           -r 25 -vb 30M -crf 18 \
            $dir_path/$name &
    
    FFMPEG_PID=$(jobs -pr)
    [[ "$FFMPEG_PID" ]] || printf 0 > $REC_STATUS_FILE
done