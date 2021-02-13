#!/bin/bash

# earth owl mouse position

source ~/.config/polybar/modules/color.sh

SIZE=10
LIMIT=10
OWL_ICON=$(echo -e "\U1f989")
MPOS=$(xdotool getmouselocation | awk -F\  '{ print $1 $2 }' | grep -E -o '[0-9]{1,4}')
IFS='
'
pos=($MPOS)
out_message="${pos[0]}x${pos[1]}"

if [ "${pos[0]}" -ge 0 ] && [ "${pos[1]}" -ge 0 ] &&
   [ "${pos[0]}" -le 32 ] && [ "${pos[1]}" -le 26 ] ; then
	out_message="-- MENU --"
fi

printf "%s %${SIZE}.${LIMIT}s"  "$OWL_ICON" $out_message
