#!/bin/bash

source ~/.config/polybar/modules/Color.bash

JSON_READER_PATH="$HOME/.config/polybar/modules/json-reader.py"

if [ "$1" ]; then
	/opt/whatsapp-desktop/WhatsApp --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36" &
	exit 0
fi

[[ "$(shmm i3-whatsapp-count -e)" -eq 0 ]] &&
	shmm i3-whatsapp-count -a 4 &&
	shmm i3-whatsapp-count -w 0

if [ "$(shmm i3-WhatsView -p)" ]; then
	data_json="$(shmm i3-WhatsView -r)"
	messages_count="$(echo "$data_json" | python $JSON_READER_PATH items-count)"

	if [ $messages_count -gt 0 ]; then
		let index="$(shmm i3-whatsapp-count -r) % $messages_count"

		contact="$(echo "$data_json" | python $JSON_READER_PATH items.$index.contact)"
		received_at="$(echo "$data_json" | python $JSON_READER_PATH items.$index.received_at)"
		preview="$(echo "$data_json" | python $JSON_READER_PATH items.$index.preview)"

		#[[ "$(shmm i3-whatsapp-switch -r)" -eq 0 ]] &&
		#	let index="$index + 1" &&
		#	printf " ${GREEN}${contact::10}" ||
		#	printf "${preview:0:2} ${YELLOW}${preview:2}"

		printf " ${GREEN}${contact::10}"
		printf ": ${YELLOW}${preview:2:20}\n"

		let index="$index + 1" 
		shmm i3-whatsapp-count -w "$index"
	else
		# printf "${GREEN}(0 Messages)"
		echo
	fi

else
	# printf ": ${RED}OFFLINE"
	echo
fi
echo ""
