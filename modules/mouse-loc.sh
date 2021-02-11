#!/bin/bash

# earth owl mouse position

source ~/.config/polybar/modules/color.sh

MPOS=$(xdotool getmouselocation | grep -E -o "[0-9]{1,4}" | head -2)
IFS='
'
pos=($MPOS)

if	[ "${pos[0]}" -ge 4 ] && [ "${pos[1]}" -ge 4 ] &&
	[ "${pos[0]}" -le 24 ] && [ "${pos[1]}" -le 24 ] ; then
	echo "Hoohoooo!"
	exit 0
fi

echo -e "\U1f989 ${pos[0]}x${pos[1]}"
