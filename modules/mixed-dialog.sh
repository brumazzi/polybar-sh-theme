#!/bin/bash

CARD_01="HDA NVidia"
CARD_02="USB Audio"
CARD_03="HD-Audio Generic"

LOOP=1

while [ "$LOOP" ]; do
	option=$(dialog --stdout --menu "Mixer" 0 0 0 stdout "Select output audio card" volume "Select outoup volume")

	if [ "$option" == 'stdout' ]; then
		card="1"
		while [ "$card" ]; do
			card=$(dialog --stdout --menu "Audio card" 0 0 0 1 "$CARD_01" 2 "$CARD_02" 3 "$CARD_03")
			if [ "$card" != "" ]; then
				let card="$card - 1"
				pactl set-default-sink $card
			fi
		done
	elif [ "$option" == 'volume' ]; then
		volume=""
		default_sink=$(pactl get-default-sink)
		default_volume=$(pactl get-sink-volume "$default_sink")
		default_volume="${default_volume#*/}"
		default_volume=${default_volume::5}
		default_volume=${default_volume/%%/}
		while [ "$volume" ]; do
			volume=$(dialog --stdout --rangebox "Volume" 0 0 0 100 $default_volume)
			if [ "$volume" != "" ]; then
				volume="$(echo $volume / 100 | bc -l)"
				volume=${volume::3}
				pactl set-default-sink $default_sink $volume
			fi
		done
	else
		LOOP=""
	fi
done
