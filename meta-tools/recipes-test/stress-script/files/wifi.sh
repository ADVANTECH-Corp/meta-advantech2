#!/bin/sh

SSID=$1
WPA_KEY=$2

if [ "$#" -ne 2 ]; then
	echo "Please input 2 arguments!"
	exit
fi

ifconfig wlan0 up
wpa_passphrase ${SSID} ${WPA_KEY} > /tmp/wpa.conf
wpa_supplicant -BDwext -iwlan0 -c/tmp/wpa.conf
udhcpc -b -i wlan0
sleep 5

ping 8.8.8.8
