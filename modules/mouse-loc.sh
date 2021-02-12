#!/bin/bash

# earth owl mouse position

source ~/.config/polybar/modules/color.sh

SIZE=10
LIMIT=12
OWL_ICON=$(echo -e "\U1f989")
MPOS=$(xdotool getmouselocation | awk -F\  '{ print $1 $2 }' | grep -E -o '[0-9]{1,4}')
IFS='
'
pos=($MPOS)
out_message="${pos[0]}x${pos[1]}"

#if [ "${pos[0]}" -ge 4 ] && [ "${pos[1]}" -ge 4 ] &&
#   [ "${pos[0]}" -le 24 ] && [ "${pos[1]}" -le 24 ] ; then
#	out_message="Hoohoooo!"
#fi
if [ "${pos[0]}" -ge 780 ] && [ "${pos[1]}" -ge 747 ] &&
   [ "${pos[0]}" -le 910 ] && [ "${pos[1]}" -le 767 ] ; then
	alt_coun_changed=$(cat /tmp/alt-coin-changed.tmp)
	out_message=${alt_coun_changed}
	let SIZE=$SIZE+2
fi

printf "%s %${SIZE}.${LIMIT}s"  "$OWL_ICON" $out_message
