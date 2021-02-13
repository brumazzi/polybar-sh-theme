#!/bin/sh

TMP_FILE=/tmp/alt-coin-changed.tmp

if [ "$1" == "" ]; then
	TMP_STAGE=/tmp/alt-coin-stage.tmp
	[[ -f $TMP_FILE ]] || printf "-"
	price=$(cat $TMP_FILE | awk -F\  '{ print $1 }')
	change=$(cat $TMP_FILE | awk -F\  '{ print $2 }')
	icon=$(cat $TMP_FILE | awk -F\  '{ print $3 }')
	if [ -f $TMP_STAGE ]; then
		if [ "$(cat $TMP_STAGE)" -eq "1" ]; then
			printf "$%s" ${price:1}
		else
			printf "%s%% %s" $change ${icon::1}
		fi
	else
		printf 1 > $TMP_STAGE
	fi
	exit 0
fi

ALTC_RUNNING=/tmp/alt-coin-running.tmp
[[ -f $ALTC_RUNNING ]] && exit 0
echo 1 > $ALTC_RUNNING
while [ 1 ]; do
	[[ -f $ALTC_RUNNING ]] || exit 0
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

	printf "|$price $changed $icon|" > /tmp/alt-coin-changed.tmp
	sleep 5
done
