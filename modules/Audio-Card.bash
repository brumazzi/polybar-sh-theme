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

card_list_id=""
card_list_name=""
card_list_icon=""

MODE="$(i3-msg -s $(i3 --get-socketpath) -t get_binding_state)" && MODE="${MODE:9:-2}"

# current_i3-CardIndex="" # current_i3-CardIndex loss value when enter in if condition
[[ "$(shmm i3-CardIndex -p)" ]] || shmm i3-CardIndex -a 4

while [ $index -le $audio_cards_count ]; do
	line="$(pactl list short sinks | awk "NR==$index")"

	card_id="$(echo $line | awk -F\  '{ print $1 }')"
	card_name="$(echo $line | awk -F\  '{ print $2 }')"
	card_status="$(echo $line | awk -F\  '{ print $7 }')"

	if [ -f "$CARD_MNEMONIC" ]; then
		mnemonic="$(cat $CARD_MNEMONIC | grep "$card_name")"
		if [ "$mnemonic" ]; then
			card_name="$(echo $mnemonic | awk -F\  '{ print $1 }')"
			current_card_icon="$(echo $mnemonic | awk -F\  '{ print $3 }')"
		fi
	fi

	if [ "$card_status" == "RUNNING" ]; then
		#current_card_target="$current_card"
		#current_card="$card_name"
		#current_card_id="$card_id"
		# current_i3-CardIndex="$index"
		shmm i3-CardIndex -w $index
	fi

	card_list_id="$card_list_id $card_id"
	card_list_name="$card_list_name $card_name"
	card_list_icon="$card_list_icon $current_card_icon"

	let index="$index + 1"
done

card_list_id=($card_list_id)
card_list_name=($card_list_name)
card_list_icon=($card_list_icon)

if [ "${MODE^^}" == "AUDIO CARD" ]; then
	index=0
	cindex=0

	if [ "$current_card_id" == "" ]; then
		IFS="|"
		card_data=($(cat $CARD_SELECTED))
		IFS=" "
		current_card_id="${card_data[2]}"
	fi

	while [ $index -lt ${#card_list_id[@]} ]; do
		cid=${card_list_id[$index]}
		cname="${card_list_name[$index]}"
		cicon="${card_list_icon[$index]}"

		if [ "$cid" == "$current_card_id" ]; then
			cindex=$index
			printf "${BG_BLUE}${DARK} <$cicon $cname> ${NO_F_COLOR}${NO_B_COLOR} "
		else
			printf "%%{A1:bash $0 $cid:} $cicon $cname %%{A} "
		fi

		let index="$index + 1"
	done

	if [ "$1" == "+" ]; then
		let cindex="$cindex + 1"
		if [ $cindex -ge ${#card_list_id[@]} ]; then
			let cindex=0
		fi
		pactl set-default-sink "${card_list_id[$cindex]}"
		#printf "${card_list_icon[$cindex]}: $BLUE${card_list_name[$cindex]}$NO_F_COLOR" > ~/.alsacard-target
		printf "${card_list_icon[$cindex]}|${card_list_name[$cindex]}|${card_list_id[$cindex]}" > ~/.alsacard-target
	elif [ "$1" == "-" ]; then
		let cindex="$cindex - 1"
		if [ $cindex -lt 0 ]; then
			let cindex="${#card_list_id[@]} - 1"
		fi
		pactl set-default-sink "${card_list_id[$cindex]}"
		#printf "${card_list_icon[$cindex]}: $BLUE${card_list_name[$cindex]}$NO_F_COLOR" > ~/.alsacard-target
		printf "${card_list_icon[$cindex]}|${card_list_name[$cindex]}|${card_list_id[$cindex]}" > ~/.alsacard-target
	else
		index=0
		for cid in ${card_list_id[@]}; do
			if [ "$cid" == "$1" ]; then
				pactl set-default-sink "$cid"
				#printf "${card_list_icon[$index]}: $BLUE${card_list_name[$index]}$NO_F_COLOR" > ~/.alsacard-target
				printf "${card_list_icon[$index]}|${card_list_name[$index]}|${card_list_id[$index]}" > ~/.alsacard-target
				break
			fi
			let index="$index + 1"
		done
	fi

	exit 0
elif [ "$1" == 1 ]; then
	exit 0
fi

# if [ "$1" ]; then
# 	polybar-widget sound-card
# else
printf "%%{A1:polybar-widget sound-card:}%%{T1}("
if [ -f $CARD_SELECTED ]; then
	IFS="|"
	card_data=($(cat $CARD_SELECTED))
	printf "${card_data[0]}: $BLUE${card_data[1]}$NO_F_COLOR"
else
	if [ "$current_card" == "" ]; then
		printf "(${BLUE} Not Playing ${LIGHT})"
	else
		printf "$current_card_icon: ${BLUE}$current_card"
	fi
fi
printf "%%{A})"
# fi
