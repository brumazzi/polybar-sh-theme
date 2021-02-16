#!/bin/sh

source ~/.config/polybar/modules/color.sh

kmap=$(cat ~/.config/polybar/modules/keymap-default)
BTN=0
ICON=$(echo -e "\u2328")
[[ "$1" ]] && BTN="$1"
[[ "$kmap" ]] || kmap=alt_i

if [ "$BTN" -eq 1 ]; then
	if [ "$kmap" == "agr_i" ]; then
		setxkbmap -layout us -variant alt-intl
		kmap=alt_i
	elif [ "$kmap" == "alt_i" ]; then
		setxkbmap -layout us -variant altgr-intl
		kmap=agr_i
	fi
fi

echo $kmap > ~/.config/polybar/modules/keymap-default
printf "$ICON: $BLUE$kmap"
