#!/bin/bash

BG_FOLDER=$(cat ~/.polybg)

[[ "$BG_FOLDER" == "" ]] && BG_FOLDER=$1

_IMD=~/.config/polybar/bg/$BG_FOLDER
_TMPF=/tmp/i3bg.tmpF
_TMPM=/tmp/i3bg.tmpM
_TMP=/tmp/i3bg.tmp


[[ -d "$_IMD" ]] || mkdir $_IMD -p

ls $_IMD -1 > ${_TMPF}
ls $_IMD -1 | wc -l > ${_TMPM}
[[ -f "$_TMP" ]] || printf 0 >> $_TMP

INDEX=$(cat $_TMP)

LF=$(cat $_TMPF)
IFS='
'
LIST=($LF)

feh --bg-scale "${_IMD}/${LIST[$INDEX]}"
let INDEX="$INDEX+1"
[[ "$INDEX" -ge "$(cat $_TMPM)" ]] && INDEX=0
printf $INDEX > $_TMP
