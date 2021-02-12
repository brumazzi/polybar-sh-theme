#!/bin/sh

source ~/.config/polybar/modules/color.sh

[[ "$1" ]] || exit 0
coins=$(curl https://poloniex.com/public?command=returnTicker 2> /dev/null)

DTA=$(echo "let coinsJSON = $coins;
console.log(\`\${parseFloat(coinsJSON.$1.last).toFixed(2)}:\${(parseFloat(coinsJSON.$1.percentChange)*100).toFixed(2)}\`)" | node)

price=$(echo $DTA | awk -F: '{ print $1 }')
changed=$(echo $DTA | awk -F: '{ print $2 }')
price_grow=$(echo "console.log($changed > 0 ? 1 : 0)" | node)
coin=$(echo $1 | awk -F_ '{ print $2 }')

if [ "$price_grow" -eq 1 ]; then
	color=$GREEN
	icon=$(echo -e "\U1f4c8")
else
	color=$RED
	icon=$(echo -e "\U1f4c9")
fi

printf "$changed%% $icon" > /tmp/alt-coin-changed.tmp

[[ "$1" ]] && printf "\$${price}"
