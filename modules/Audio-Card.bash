#!/bin/bash

source ~/.config/polybar/modules/Color.bash

CARD_MNEMONIC="$HOME/.alsacard-mnemonic"
CARD_SELECTED="$HOME/.alsacard-target"

audio_cards_count="$(pactl list short sinks | wc -l)"
index=1
current_card=""
current_card_id=""
current_card_icon=""
current_card_target=""

# current_card_index="" # current_card_index loss value when enter in if condition
[[ "$(shmm card_index -p)" ]] || shmm card_index -a 4

while [ $index -le $audio_cards_count ]; do
	line="$(pactl list short sinks | awk "NR==$index")"

	card_id="$(echo $line | awk -F\  '{ print $1 }')"
	card_name="$(echo $line | awk -F\  '{ print $2 }')"
	card_status="$(echo $line | awk -F\  '{ print $7 }')"

	if [ "$card_status" == "RUNNING" ]; then
		if [ -f "$CARD_MNEMONIC" ]; then
			mnemonic="$(cat $CARD_MNEMONIC | grep "$card_name")"
			if [ "$mnemonic" ]; then
				card_name="$(echo $mnemonic | awk -F\  '{ print $1 }')"
				current_card_icon="$(echo $mnemonic | awk -F\  '{ print $3 }')"
			fi
		fi
		current_card_target="$current_card"
		current_card="$card_name"
		current_card_id="$card_id"
		# current_card_index="$index"
		shmm card_index -w $index
	fi
	let index="$index + 1"
done

# if [ "$1" ]; then
# 	polybar-widget sound-card
# else
if [ -f $CARD_SELECTED ]; then
	cat $CARD_SELECTED
else
	if [ "$current_card" == "" ]; then
		printf "(${BLUE} Not Playing ${LIGHT})"
	else
		printf "$current_card_icon: ${BLUE}$current_card"
	fi
fi
# fi
