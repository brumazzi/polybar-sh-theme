#!/bin/sh

source ~/.config/polybar/modules/color.sh
source ~/.config/polybar/modules/progress-bar.sh

function network_bytes {
	LAST=$(cat /tmp/network-bytes.tmp)
	if [ $LAST ]; then
		echo "$LAST-$(cat /sys/class/net/$1/statistics/rx_bytes)" | bc
	else
		cat /sys/class/net/$1/statistics/rx_bytes
	fi

	cat /sys/class/net/$1/statistics/rx_bytes > /tmp/network-bytes.tmp
}

btn=0
[[ "$1" ]] && btn=$1

ETH=$(ip addr show eth0 | grep inet | grep -E -o '[0-9.]{7,15}')
EIP=$(echo $ETH | awk -F' ' '{print $1}')
EMASK=$(echo $ETH | awk -F' ' '{print $2}')
EBROADCAT=$(echo $ETH | awk -F' ' '{print $3}')

WLAN=$(ip addr show wlp3s0 | grep inet | grep -E -o '[0-9.]{7,15}')
WIP=$(echo $WLAN | awk -F' ' '{print $1}')
WMASK=$(echo $WLAN | awk -F' ' '{print $2}')
WBROADCAT=$(echo $WLAN | awk -F' ' '{print $3}')

IP=""
if [ "$EIP" ] && [ "$WIP" ]; then
	DATE=$(date '+%S')
	MOD=$(echo "$DATE % 2" | bc)
	if [ "$MOD" -eq 1 ]; then
		ICON="\U1f5a7"
		IP="$EIP"
	else
		ICON="\U1f30e"
		IP="$WIP"
	fi
elif [ "$EIP" ]; then
	ICON="\U1f5a7"
	IP="$EIP"
elif [ "$WLAN" ]; then
	ICON="\U1f30e"
	IP="$WIP"
fi

[[ $IP ]] || exit 0

echo -e "$ICON: $IP"
