#!/bin/bash

# source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/progress-bar.sh

MEM_FILE="/proc/meminfo"
MEM_TEXT_L="- - M E M O R Y - -"
SWP_TEXT_L="- - - S W A P - - -"
IFS=' '
MEM_TEXT=($MEM_TEXT_L)
SWP_TEXT=($SWP_TEXT_L)

MEM_MAX=$(cat $MEM_FILE | grep MemTotal | grep -E -o '[0-9]{1,10}')
MEM_FREE=$(cat $MEM_FILE | grep MemFree | grep -E -o '[0-9]{1,10}')
MEM_AVAL=$(cat $MEM_FILE | grep MemAvailable | grep -E -o '[0-9]{1,10}')

SWAP_MAX=$(cat $MEM_FILE | grep SwapTotal | grep -E -o '[0-9]{1,10}')
SWAP_FREE=$(cat $MEM_FILE | grep SwapFree | grep -E -o '[0-9]{1,10}')

function porcent_mem {
	PORC=$(echo "$MEM_AVAL*100/$MEM_MAX" | bc -l)
	echo $PORC | cut -c 1-6
}

function porcent_swap {
	PORC=$(echo "$SWAP_FREE*100/$SWAP_MAX" | bc -l)
	echo $PORC | cut -c 1-6
}

if [ "$1" == "MEM" ]; then
	progress_bar $MEM_MAX $MEM_AVAL "$MEM_TEXT_L" $PROGRESS_MEM_BG 10
elif [ "$1" == "SWAP" ]; then
	progress_bar $SWAP_MAX $SWAP_FREE "$SWP_TEXT_L" $PROGRESS_SWAP_BG 10
fi

