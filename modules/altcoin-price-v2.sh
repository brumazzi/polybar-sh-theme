#!/bin/sh

TMP_FILES=/tmp/shm-*
source ~/.config/polybar/modules/color.sh

[[ -x /usr/bin/node ]] || echo "NodeJS Not Found!" && exit 1

if [ "$1" == "" ]; then
	TMP_STAGE=/tmp/alt-coin-stage.tmp
	data_price="$GRAY |$NO_F_COLOR"
	data_percent="$GRAY |$NO_F_COLOR"

	for TMP_FILE in $TMP_FILES; do
		[[ -f $TMP_FILE ]] || printf " FINDING... "

		coin_alias=${TMP_FILE:9:-4}
		coin_data=$(shmm $coin_alias -r)

		price=$(echo $coin_data | awk -F\  '{ print $1 }')
		change=$(echo $coin_data | awk -F\  '{ print $2 }')
		coin=$(echo $coin_data | awk -F\  '{ print $3 }')

		[[ "${price:1}" == "" ]] && printf " No coin data " && exit 0
		price_grow=$(echo "console.log($change > 0 ? 1 : 0)" | /usr/bin/node)

		if [ "$price_grow" -eq "0" ]; then
			bar="$BAR_RED"
			show_coin="${coin}"
			color="$RED"
			icon=$(echo -e "\U1f4c9")
		else
			bar="$BAR_GREEN"
			show_coin="${coin}"
			color="$GREEN"
			icon=$(echo -e "\U1f4c8")
		fi

		data_price="$BAR_GREEN$NO_F_COLOR$data_price ${coin}: $color\$${price} $GRAY|$NO_F_COLOR"
		data_percent="$bar$NO_F_COLOR$data_percent $show_coin: $color$change%% $icon $GRAY|$NO_F_COLOR"
	done

	if [ -f $TMP_STAGE ]; then
		if [ "$(cat $TMP_STAGE)" -eq "1" ]; then
			printf "$data_price "
		else
			printf "$data_percent "
		fi
	else
		printf 1 > $TMP_STAGE
	fi
	exit 0
fi
