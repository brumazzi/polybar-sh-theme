#!/bin/bash

ICON_TEMPERATURE=""
ICON_HUMIDITY=""
ICON_VISIBILITY=""
ICON_WIND=""

weather-icon() {
	local code=$1
	local is_day=$2
	[[ "$is_day" == "" ]] && is_day=1

	case $code in
	1000) 
		if [ $is_day -eq 1 ]; then
			echo ""
		else
			echo ""
		fi
		;;
	1003) 
		if [ $is_day -eq 1 ]; then
			echo ""
		else
			echo ""
		fi
		;;
	1006|1009) echo "" ;;
	1030|1135|1147) echo "" ;;
	1063|1150|1153|1180|1183|1186|1189|1192|1195|1240|1243|1246) 
		if [ $is_day -eq 1 ]; then
			echo ""
		else
			echo ""
		fi
		;;
	1066|1210|1213|1216|1219|1222|1225|1255|1258) 
		echo ""
		;;
	1069|1204|1207|1249|1252) echo "" ;;
	1072|1168|1171|1198|1201) echo "" ;;
	1087|1273|1276) 
		echo ""
		;;
	1114|1117) echo "" ;;
	1237|1261|1264) echo "🧊" ;;
	1279|1282) 
		echo ""
		;;
	*) echo "🌍" ;;
esac
}
