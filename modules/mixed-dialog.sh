#!/bin/bash

CARD_01="USB Audio"
CARD_02="HDA NVidia"
CARD_03="HD-Audio Generic"

LOOP=1

WMCLASS="floating"
WMCLASS="app-menu"

while [ "$LOOP" ]; do
	option=$(Xdialog --wmclass $WMCLASS --under-mouse --title "Mixer" --stdout --menubox "Mixer" 15 45 15 audiocard "Select output audio card" volume "Select outoup volume")

	if [ "$option" == 'audiocard' ]; then
		card="1"
		while [ "$card" ]; do
			card=$(Xdialog --stdout --under-mouse --wmclass $WMCLASS --title "Audio card" --menu "Audio card" 15 50 0 1 "$CARD_01" 2 "$CARD_02" 5 "$CARD_03")
			if [ "$card" != "" ]; then
				let card="$card"
				pactl set-default-sink $card
			fi
		done
	elif [ "$option" == 'volume' ]; then
		volume="1"
		default_sink=$(pactl get-default-sink)
		default_volume=$(pactl get-sink-volume "$default_sink")
		default_volume="${default_volume#*/}"
		default_volume=${default_volume::5}
		default_volume=${default_volume/%%/}
		while [ "$volume" ]; do
			volume=$(Xdialog --wmclass $WMCLASS --under-mouse --stdout --title "Volume" --rangebox "Volume" 15 50 0 100 $default_volume)
			if [ "$volume" != "" ]; then
				volume="$(echo $volume / 100 | bc -l)"
				volume=${volume::3}
				eval "pactl set-default-sink \"$default_sink\" \"$volume\""
			fi
		done
	else
		LOOP=""
	fi
done
