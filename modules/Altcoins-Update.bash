#!/bin/bash

# AltCoins params
# lastUpdate:coinsCount:coinData:coinData:...

UPDATE_DELAY=20
current_time="$(date '+%Y%m%d%H%M')"

function update-coins {
	read coins_list < $HOME/.coins_name
	mapfile -d ',' list <<< "$coins_list"
	local coins_count=${#list[@]}
	unset list

	coins_list="${coins_list//\"/\%22}" # replace quotes \" by %22
	# local coins_list="$(echo $coins_list | sed 's/"/%22/g')" # using sed
	# seed can add more rules adding ';' and new rule

	local json="$(curl -s https://api.binance.com/api/v3/ticker/24hr?symbols=\%5B$coins_list\%5D)"

	if [ "$json" ]; then
		local coins_data=""
		mapfile -t symbols <<< $(jq '.[].symbol' <<< "$json")
		mapfile -t prices <<< $(jq '.[].askPrice' <<< "$json")
		mapfile -t percents <<< $(jq '.[].priceChangePercent' <<< "$json")
		for ((i=0;i<${#symbols[@]};i++)); do
			local symbol=${symbols[$i]}
			local price=${prices[$i]}
			local percent=${percents[$i]}
			symbol=${symbol/USDT/}
			coins_data="${coins_data}${symbol//\"/},${price//\"/},${percent//\"/}:"
		done

		shmm i3-CoinPrice -w "$current_time:$coins_count:$coins_data"
	fi
}

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
