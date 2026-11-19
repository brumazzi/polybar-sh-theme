#!/bin/bash

declare -a IFACES
SPEED_PREFIX=(B KB MB GB TB)

mapfile -t ip_data <<< "$(ip -br addr | grep UP)"

for line in "${ip_data[@]}"; do
	vec=($line)
	count=${#IFACES[@]}
	IFACES[${#IFACES[@]}]="${vec[0]}"

	if [ "$(shmm i3-Network-${IFACES[$count]} -e)" -eq "0" ]; then
		shmm i3-Network-${IFACES[$count]} -a 32
		shmm i3-Network-${IFACES[$count]}-speed -a 32
	fi
done

max_ifaces=${#IFACES[@]}
for (( index=0; index<max_ifaces; index++)); do
	send=$(cat /sys/class/net/${IFACES[$index]}/statistics/rx_bytes)
	recv=$(cat /sys/class/net/${IFACES[$index]}/statistics/tx_bytes)

	saved_data=$(shmm i3-Network-${IFACES[$index]} -r)
	shmm i3-Network-${IFACES[$index]} -w "$send $recv"
	if [ "$saved_data" == "" ]; then
		echo "Not Syncronized"
		continue
	fi

	saved_data=($saved_data)
	mem_send=${saved_data[0]}
	mem_recv=${saved_data[1]}

	send_speed="$((send - mem_send))"
	recv_speed="$((recv - mem_recv))"

	# send_prefix_index=0
	# while [ $send_speed -gt 1024 ]; do
	# 	send_speed=$(($send_speed/1024))
	# 	let send_prefix_index="$send_prefix_index + 1"
	# done

	# recv_prefix_index=0
	# while [ $recv_speed -gt 1024 ]; do
	# 	recv_speed=$(($recv_speed/1024))
	# 	let recv_prefix_index="$recv_prefix_index + 1"
	# done
	shmm i3-Network-${IFACES[$index]}-speed -w "$send_speed $recv_speed"
done
