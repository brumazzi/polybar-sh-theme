#!/bin/bash

# AltCoins params
# lastUpdate:coinsCount:coinData:coinData:...

JSON_READER_PATH="$HOME/.config/polybar/modules/json-reader.py"
UPDATE_DELAY=20
current_time="$(date '+%Y%m%d%H%M')"

function update-coins {
	local coins_list="$(cat $HOME/.coins_name)"
	local coins_count=0
	
	let coins_count="$(echo $coins_list | awk -F',' '{print NF-1}') + 1"
	coins_list="${coins_list//\"/\%22}" # replace quotes \" by %22
	# local coins_list="$(echo $coins_list | sed 's/"/%22/g')" # using sed
	# seed can add more rules adding ';' and new rule

	local json="$(curl -s https://api.binance.com/api/v3/ticker/24hr?symbols=\%5B$coins_list\%5D)"

	if [ "$json" ]; then
		local coins_data=""
		for ((i=0;i<$coins_count;i++)); do
			local coin_data="$(echo $json | python $JSON_READER_PATH $i.symbol $i.askPrice $i.priceChangePercent)"
			coin_data="${coin_data//:/,}"
			coin_data="${coin_data//USDT/}"
			coins_data="${coins_data}$coin_data:"
		done

		shmm i3-CoinPrice -w "$current_time:$coins_count:$coins_data"
	fi
}

[[ ! -f "$JSON_READER_PATH" ]] && echo $JSON_READER_PATH not exists && exit 1

if [ "$(shmm i3-CoinPrice -p)" ]; then
	data="$(shmm i3-CoinPrice -r)"
	[[ "$data" ]] || data=0

	last_update="${data::12}"
	let pass_time="$current_time - $last_update"
	if [ "$pass_time" -gt "$UPDATE_DELAY" ]; then
		update-coins
	fi
else
	update-coins
fi

echo ""
