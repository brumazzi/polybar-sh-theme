#!/bin/bash

BG_FOLDER=$HOME/.local/share/backgrounds
BG_PATH="$(cat $HOME/.polybg)"
CHANGE_DELAY="9"

if [ "$(shmm i3-BG -p)" ]; then
	[[ "$(shmm i3-BGDelay -r)" == "" ]] && shmm i3-BGDelay -w "$CHANGE_DELAY" && echo RESET
fi

[[ ! -e "$BG_PATH" ]] && BG_PATH="$BG_FOLDER/$BG_PATH"

if [ -d $BG_PATH ]; then
	IFS=':' read -a bg_info <<< $(shmm i3-BG -r)
	dir=${bg_info[1]}
	mapfile -t dir_files <<< $(ls -1 $dir)
	let i_index=${bg_info[0]}
	delay="$(shmm i3-BGDelay -r)"

	[[ "$dir" != "$BG_PATH" ]] && dir="$BG_PATH" && i_index="0" && delay="0"
	if [ $delay -gt 0 ]; then
		let delay="$delay-1"
		shmm i3-BGDelay -w "$delay"
		exit 0
	fi
	let img_count="${#dir_files[@]}"
	next_img=${dir_files[$i_index]}
	
	let i_index="(${i_index} + 1)%${#dir_files[@]}"

	shmm i3-BG -w "${i_index}:${dir}"
	shmm i3-BGDelay -w "$CHANGE_DELAY"
	feh --bg-scale "$dir/${next_img}"

elif [ -f $BG_PATH ]; then
	IFS=':' read -a bg_info <<< $(shmm i3-BG -r)
	img="${bg_info[1]}"
	if [ "$img" != "$BG_PATH" ]; then
		shmm i3-BG -w "0:$BG_PATH"
		feh --bg-scale $BG_PATH
	fi
else
	exit 0
fi

printf " "
