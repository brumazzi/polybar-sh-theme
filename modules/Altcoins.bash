#!/bin/sh

source ~/.config/polybar/modules/Color.bash
source ~/.config/polybar/modules/Altcoins-Icons.bash

if [ "$(shmm i3-CoinPrice -p)" == "" ]; then
	echo " "
	exit 0
fi

IFS=":" read -a COINS_DATA <<< "$(shmm i3-CoinPrice -r)"

if [ "${#COINS_DATA[@]}" -lt 3 ]; then
	printf "$RED$BAR_RED NOT SYNCRONIZED "
	exit 0
fi

mode="$(shmm i3-CoinMode -r)"

if [ "$1" == "" ]; then
	coins_count=${COINS_DATA[1]}
	coins_print="$NO_F_COLOR$BAR_DARK"

	for ((i=0;i<$coins_count;i++)); do
		let index="$i + 2"
		IFS="," read -a coin <<< ${COINS_DATA[$index]}

		symbol=${coin[0]}
		price=${coin[1]}
		percent=${coin[2]}

		mode_data=""
		symbol=$(coins-icon $symbol)

		[[ "$mode" -eq 0 ]] &&
			mode_data="%%{T4}\$%%{T-}${price::10}" ||
			mode_data="$percent%%"

		bar_color=""
		text_color=""

		if [ "${percent::1}" == '-' ]; then
			bar_color="$BAR_RED"
			text_color="$RED"
		else
			bar_color="$BAR_GREEN"
			text_color="$GREEN"
		fi

		coin_show_data=" $bar_color %%{T6}${LIGHT}$symbol%%{T-}: $text_color$mode_data  $NO_F_COLOR$BAR_DARK "

		coins_print="${coins_print}${coin_show_data}"
	done

	printf "$coins_print"
elif [ "$1" == "1" ]; then
	[[ "$mode" -eq 1 ]] &&
		shmm i3-CoinMode -w 0 ||
		shmm i3-CoinMode -w 1
fi
