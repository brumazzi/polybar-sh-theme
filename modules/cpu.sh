#!/bin/bash

CINFO="/proc/cpuinfo"

CPU_VENDOR=$(cat $CINFO | grep 'vendor_id' | head -1)
CPU_MODEL=$(cat $CINFO | grep 'model name' | head -1)
CPU_MHZ=$(cat $CINFO | grep 'cpu MHz')
CPU_CACHE=$(cat $CINFO | grep 'cache size')

IFS='
'
mhz=($CPU_MHZ)
cache=($CPU_CACHE)

ghz=$(echo $CPU_MODEL | awk -F' ' '{print $9}' | grep -E -o '[0-9.]{1,10}')
ghz=$(echo $ghz*1024 | bc -l)

_MAX_GHz=$ghz

_PORC=""
for ((X=0; X<4; X+=1)); do
	let n="$X+1"
	atual=$(echo ${mhz[$X]} | awk -F': ' '{print $2}')
	p=$(echo "(${atual}*100)/$_MAX_GHz" | bc -l)
	_PORC="$_PORC | CPU[$X]: $p"
done

printf "%s" "$_PORC"
