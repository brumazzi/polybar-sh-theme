#!/bin/sh

source ~/.config/polybar/modules/Color.bash

ICON=$(echo -e "\Uf11c")
kmap=$(shmm i3-kmap -r)
BTN=0
[[ "$1" ]] && BTN="$1"

IBUS="$(pgrep ibus-daemon)"

if [ "$kmap" == "" ]; then
	kmap="xkb:us:alt-intl:eng"

	if [ "$IBUS" ]; then
		ibus engine xkb:us:alt-intl:eng
		kmap=$(ibus engine)
	else
		setxkbmap -layout us -variant alt-intl
	fi
	shmm i3-kmap -w xkb:us:alt-intl:eng
fi

if [ ! "$IBUS" ]; then
	if [ "$BTN" -eq 1 ]; then
		if [ "$kmap" == "xkb:us:altgr-intl:eng" ]; then
			setxkbmap -layout us -variant alt-intl
			kmap=xkb:us:alt-intl:eng
		elif [ "$kmap" == "xkb:us:alt-intl:eng" ]; then
			setxkbmap -layout us -variant altgr-intl
			kmap=xkb:us:altgr-intl:eng
		fi
		shmm i3-kmap -w $kmap
	fi
else
	kmap="$(ibus engine)"
	shmm i3-kmap -w $kmap
	if [ "$BTN" -eq 2 ]; then
		if [ "$kmap" == "xkb:us:altgr-intl:eng" ]; then
			ibus engine mozc-jp
		elif [ "$kmap" == "xkb:us:alt-intl:eng" ]; then
			ibus engine xkb:us:altgr-intl:eng
		elif [ "$kmap" == "mozc-jp" ]; then
			ibus engine xkb:us:alt-intl:eng
		fi
	elif [ "$BTN" -eq 1 ]; then
		xdotool key super+space
	fi
	kmap="$(ibus engine)"
fi

if [ "$kmap" == "xkb:us:altgr-intl:eng" ]; then
	kmap="US-Agr"
elif [ "$kmap" == "xkb:us:alt-intl:eng" ]; then
	kmap="US-Int"
elif [ "$kmap" == "mozc-jp" ]; then
	kmap="JP-"
fi

printf "$ICON: $BLUE$kmap"
