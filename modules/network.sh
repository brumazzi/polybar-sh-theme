#!/bin/sh

source ~/.config/polybar/modules/color.sh

btn=0
[[ "$1" ]] && btn=$1

ETH=$(ip addr show enp5s0 | grep inet | grep -E -o '[0-9.]{7,15}')
EIP=$(echo $ETH | awk -F' ' '{print $1}')
EMASK=$(echo $ETH | awk -F' ' '{print $2}')
EBROADCAT=$(echo $ETH | awk -F' ' '{print $3}')

#WLAN_SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^sim' | cut -d\: -f2)
#WLAN=$(ip addr show wlp3s0 | grep inet | grep -E -o '[0-9.]{7,15}')
#WIP=$(echo $WLAN | awk -F' ' '{print $1}')
#WMASK=$(echo $WLAN | awk -F' ' '{print $2}')
#WBROADCAT=$(echo $WLAN | awk -F' ' '{print $3}')

v=$(ping google.com.br -W 100 -c 1 2> /dev/null)
[[ "$?" -ne "0" ]] && printf "${YELLOW}No Network" && exit 0

IP=""
if [ "$EIP" ] && [ "$WIP" ]; then
	DATE=$(date '+%S')
	MOD=$(echo "$DATE % 2" | bc)
	if [ "$MOD" -eq 1 ]; then
		ICON=$(echo -e "\U1f5a7")
		IP="$EIP"
	else
		ICON=$(echo -e "\U1f30e")
		IP="$WIP"
	fi
elif [ "$EIP" ]; then
	ICON=$(echo -e "\U1f5a7")
	IP="$EIP"
elif [ "$WLAN" ]; then
	ICON=$(echo -e "\U1f30e")
	IP="$WIP"
fi

[[ $IP ]] || exit 0

printf "$ICON: $YELLOW$IP"
