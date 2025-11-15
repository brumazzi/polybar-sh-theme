#!/bin/sh

source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/Altcoins-Icons.bash

function coins_data {
	shmm CoinPrice -r
}

if [ "$(coins_data | wc -c)" -le 30 ]; then
	printf "$RED$BAR_RED NOT SYNCRONIZED "
	exit 0
fi

mode="$(shmm CoinMode -r)"

if [ "$1" == "" ]; then
	coins_count=$(coins_data | awk -F: '{print $2}')
	coins_print="$NO_F_COLOR$BAR_DARK"

	for ((i=0;i<$coins_count;i++)); do
		let index="$i + 3"
		coin=$(coins_data | awk -F: "{print \$$index}")

		symbol=$(printf $coin | awk -F\, '{print $1}')
		price=$(printf $coin | awk -F\, '{print $2}')
		percent=$(printf $coin | awk -F\, '{print $3}')

		mode_data=""
		# change symbol by icon don't work in current fontaewsome version (6.5.1)
		# symbol=$(coins-icon $symbol)

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

		coin_show_data=" $bar_color $symbol: $text_color$mode_data $NO_F_COLOR$BAR_DARK "

		coins_print="${coins_print}${coin_show_data}"
	done

	printf "$coins_print"
elif [ "$1" == "1" ]; then
	[[ "$mode" -eq 1 ]] &&
		shmm CoinMode -w 0 ||
		shmm CoinMode -w 1
fi
