#!/bin/bash

BG_FOLDER=$HOME/.local/share/backgrounds
BG_PATH="$(cat $HOME/.polybg)"
CHANGE_DELAY="9"

if [ "$(shmm i3-BG -p)" ]; then
	shmm i3-BGDelay -w "$CHANGE_DELAY"
fi
[[ ! -e "$BG_PATH" ]] && BG_PATH="$BG_FOLDER/$BG_PATH"

if [ -d $BG_PATH ]; then
	dir="$(shmm i3-BG -r | awk -F: '{print $3}')"
	let i_index="$(shmm i3-BG -r | awk -F: '{print $1}')"
	delay="$(shmm i3-BGDelay -r)"

	[[ "$dir" != "$BG_PATH" ]] && dir="$BG_PATH" && i_index="0" && delay="0"
	if [ $delay -gt 0 ]; then
		let delay="$delay-1"
		shmm i3-BGDelay -w "$delay"
		exit 0
	fi

	let img_count="$(ls $dir -1 | wc -l)"
	let i_index="${i_index}%${img_count} + 1"

	next_img="$(ls $dir -1 | awk "NR == $i_index")"

	shmm i3-BG -w "${i_index}:${img_count}:${dir}"
	shmm i3-BGDelay -w "$CHANGE_DELAY"
	feh --bg-scale "$dir/${next_img}"

elif [ -f $BG_PATH ]; then
	img="$(shmm i3-BG -r | awk -F: '{print $3}')"
	if [ "$img" != "$BG_PATH" ]; then
		shmm i3-BG -w "0:0:$BG_PATH"
		feh --bg-scale $BG_PATH
	fi
else
	exit 0
fi
