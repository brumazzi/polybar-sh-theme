#!/bin/sh

source ~/.config/polybar/modules/color.sh

ICON=$(echo -e "\u2328")
kmap=$(shmm kmap -r)
BTN=0
[[ "$1" ]] && BTN="$1"

IBUS="$(pgrep ibus-daemon)"


if [ "$kmap" == "" ]; then
	shmm kmap --alloc 32
	kmap="alt_i"
	
	if [ "$IBUS" ]; then
		ibus engine xkb:us:alt-intl:eng
		kmap=$(ibus engine)
	else
		setxkbmap -layout us -variant alt-intl
	fi
	shmm kmap -w alt_i
fi

if [ ! "$IBUS" ]; then
	if [ "$BTN" -eq 1 ]; then
		if [ "$kmap" == "agr_i" ]; then
			setxkbmap -layout us -variant alt-intl
			kmap=alt_i
		elif [ "$kmap" == "alt_i" ]; then
			setxkbmap -layout us -variant altgr-intl
			kmap=agr_i
		fi
		shmm kmap -w $kmap
	fi
else
	kmap="$(ibus engine)"
	shmm kmap -w $kmap
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

if [ "$kmap" == "xkb:us:altgr-intl:eng" ] || [ "$kmap" == "agr_i" ] ; then
	kmap="US-Agr"
elif [ "$kmap" == "xkb:us:alt-intl:eng" ] || [ "$kmap" == "alt_i" ] ; then
	kmap="US-Int"
elif [ "$kmap" == "mozc-jp" ]; then
	kmap="JP-"
fi

printf "$ICON: $BLUE$kmap"
