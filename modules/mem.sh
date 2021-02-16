#!/bin/bash

source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/progress-bar.sh

MEM_FILE="/proc/meminfo"
MEM_TEXT_L="MEMORY:"
SWP_TEXT_L="SWAP:  "
IFS=' '
MEM_TEXT=($MEM_TEXT_L)
SWP_TEXT=($SWP_TEXT_L)

MEM_MAX=$(cat $MEM_FILE | grep MemTotal | grep -E -o '[0-9]{1,10}')
MEM_FREE=$(cat $MEM_FILE | grep MemFree | grep -E -o '[0-9]{1,10}')
MEM_AVAL=$(cat $MEM_FILE | grep MemAvailable | grep -E -o '[0-9]{1,10}')

SWAP_MAX=$(cat $MEM_FILE | grep SwapTotal | grep -E -o '[0-9]{1,10}')
SWAP_FREE=$(cat $MEM_FILE | grep SwapFree | grep -E -o '[0-9]{1,10}')

function percent_mem {
	PORC=$(echo "$MEM_AVAL*100/$MEM_MAX" | bc)
	echo $PORC | cut -c 1-6
}

function percent_swap {
	PORC=$(echo "$SWAP_FREE*100/$SWAP_MAX" | bc)
	echo $PORC | cut -c 1-6
}

if [ "$1" == "MEM" ]; then
	percent=$(percent_mem)
	text=$(printf "$MEM_TEXT_L %3.3s%%" $percent)
	text_color=$GREEN_S
	percent_with_progress="$PROGRESS_MEM$(progress_bar $MEM_MAX $MEM_AVAL "$text")"
elif [ "$1" == "SWAP" ]; then
	percent=$(percent_swap)
	text=$(printf "$SWP_TEXT_L %3.3s%%" $percent)
	text_color=$PURPLE_S
	percent_with_progress="$PROGRESS_SWAP$(progress_bar $SWAP_MAX $SWAP_FREE "$text")"
fi

echo "$percent_with_progress" | sed "s/:/:$text_color/"
