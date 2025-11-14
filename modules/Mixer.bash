#!/bin/sh

[[ "$1" ]] || [[ "$2" ]] || exit 0

VOL=$(amixer get Master | grep -E -o '[%[0-9]{1,3}%]' | head -1 | grep -E -o '[0-9]{1,3}')

if [ "$1" == "+" ]; then
	let VOL="$VOL + $2"
elif [ "$1" == "-" ]; then
	let VOL="$VOL - $2"
fi

amixer sset 'Master' "${VOL}%" > /dev/zero
