#!/bin/bash

source $HOME/.config/polybar/modules/Color.bash

IFACES=()
SPEED_PREFIX=(B KB MB GB TB)

SHOW_DOWNLOAD=0
SHOW_UPLOAD=0

for params in $@; do
    if [ "$params" == "--download" ]; then
        SHOW_DOWNLOAD=1
    elif [ "$params" == "--upload" ]; then
        SHOW_UPLOAD=1
    else
        IFACES=($param)
    fi
done

if [ "$IFACES" == "" ]; then
    mapfile -t ip_data <<< "$(ip -br addr | grep UP)"

    for line in "${ip_data[@]}"; do
        vec=($line)
        count=${#IFACES[@]}
        IFACES[${#IFACES[@]}]="${vec[0]}"
    done
fi

count=0

for iface in ${IFACES[@]}; do
    saved_data=$(shmm i3-Network-${IFACES}-speed -r)
    [[ "$count" -gt 0 ]] && printf ":"
    let count="$count + 1"

    if [ "$saved_data" == "" ]; then
        echo "Not Syncronized"
        exit 0
    fi

    saved_data=($saved_data)

    send_speed="${saved_data[0]}"
    recv_speed="${saved_data[1]}"

    send_prefix_index=0
    while [ $send_speed -gt 1024 ]; do
        send_speed=$(($send_speed/1024))
        let send_prefix_index="$send_prefix_index + 1"
    done

    recv_prefix_index=0
    while [ $recv_speed -gt 1024 ]; do
        recv_speed=$(($recv_speed/1024))
        let recv_prefix_index="$recv_prefix_index + 1"
    done

    if [ "$iface" == "enp6s0" ]; then
        printf "${LIGHT}:"
    elif [ "$iface" == "wlan0" ]; then
        printf "${LIGHT}:"
    fi

    [[ "$SHOW_DOWNLOAD" -eq 1 ]] && printf " ${YELLOW}%-4.4s%-4.4s" "${recv_speed}" "${SPEED_PREFIX[$recv_prefix_index]}/s"
    [[ "$SHOW_UPLOAD" -eq 1 ]] && printf " ${YELLOW}%-4.4s%-4.4s" "${send_speed}" "${SPEED_PREFIX[$send_prefix_index]}/s"

    if [ "$SHOW_DOWNLOAD" -eq 0 ] && [ "$SHOW_UPLOAD" -eq 0 ]; then
        data=($(ip -br addr | grep UP))
        IFS="/"
        ip=(${data[2]})
        printf "${YELLOW} ${ip[0]}"
        IFS=' '
    fi

done