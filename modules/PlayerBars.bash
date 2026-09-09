#!/bin/bash

source $HOME/.config/polybar/modules/Functions.bash
source $HOME/.config/polybar/modules/Color.bash

check-command cava
if [ "$?" -eq 1 ]; then
	echo ""
	exit 0
else
	if [ ! "$(pgrep cava)" ]; then
		echo ""
		exit 0 
	fi
fi

TIMEOUT="30"

FIFO_PATH="/dev/shm/u1000-cava_bars"
BAR_ICONS[0]="\u4c"
BAR_ICONS[1]="\u4d"
BAR_ICONS[2]="\u4e"
BAR_ICONS[3]="\u4f"
BAR_ICONS[4]="\u50"
BAR_ICONS[5]="\u51"
BAR_ICONS[6]="\u52"
BAR_ICONS[7]="\u53"
BAR_ICONS[8]="\u54"
BAR_ICONS[9]="\u55"
BAR_ICONS[10]="\u56"

COLORS=(42d6b9 42d6b9 42d6b9 7dc391 7dc391 dda34f dda34f f98b3c f98b3c db4d4d db4d4d)

status=$(playerctl status --no-messages)

printf "L|%%{T8}"
if [ "$status" != "xPlaying" ] ; then
	declare frequence
	read -t 1 -r frequence < "$FIFO_PATH"

	if [ "$frequence" ]; then
		IFS=";"
		bar_list=($frequence)
		IFS=" "
		for bar in ${bar_list[@]}; do
			let value="$bar/100"
			printf "%%{F#${COLORS[$value]}}${BAR_ICONS[$value]}"
			((half--))
		done
	fi
fi
printf "%%{T-}$LIGHT|R"
