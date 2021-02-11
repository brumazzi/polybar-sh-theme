#!/bin/sh

source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/progress-bar.sh

[[ "$1" ]] && BTN=$1 || BTN=0
VOL=$(amixer get Master | grep -E -o '[%[0-9]{1,3}%]' | head -1 | grep -E -o '[0-9]{1,3}')

if [ "$BTN" -eq 1 ]; then
	#(
	tmp=$(zenity --scale --text="Volume" --min-value=0 --max-value=100 --value=$VOL)
	VOL=$tmp
	unset tmp
	#) &
elif [ "$BTN" -eq 4 ]; then
	let VOL=$VOL+4
	if [ $VOL -ge 100 ]; then
		VOL=100
	fi
elif [ "$BTN" -eq 5 ]; then
	let VOL=$VOL-4
	if [ $VOL -le 0 ]; then
		VOL=0
	fi
fi

SYMB=""
if [ "$VOL" -eq 0 ]; then
	SYMB="\U0001f507"
elif [ "$VOL" -le 30 ]; then
	SYMB="\U0001f508"
elif [ "$VOL" -le 80 ]; then
	SYMB="\U0001f509"
elif [ "$VOL" -le 100 ]; then
	SYMB="\U0001f50a"
fi

amixer sset 'Master' "${VOL}%" > /dev/zero

echo -e "$SYMB: ${VOL}%"
