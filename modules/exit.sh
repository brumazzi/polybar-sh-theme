#!/bin/sh

BTN=0
act=""
[[ "$1" ]] && BTN=$1

if [ "$BTN" -eq 1 ]; then
	act=$(zenity --list --text="Sair?" --column="Action" Suspend Reboot Shutdown)
	if [ "$act" ]; then
		killall conky -9
#		killall nm-applet
	fi
	if [ "$act" == "Logout" ]; then
		i3-msg exit
	elif [ "$act" == "Suspend" ]; then
		loginctl suspend
	elif [ "$act" == "Hibernate" ]; then
		loginctl hibernate
	elif [ "$act" == "Reboot" ]; then
		sudo reboot
	elif [ "$act" == "Shutdown" ]; then
		sudo poweroff
	fi
fi
