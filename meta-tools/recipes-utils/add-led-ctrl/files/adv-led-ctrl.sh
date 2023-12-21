#!/bin/sh

function wifi_monitor()
{
while true
do
	wifi_status=`lspci |grep Ethernet`
	ip_address=`ifconfig | grep -A 3 mlan0 | awk '/inet/ {print $2}' | cut -f2 -d ":"`
	if [[ "e$wifi_status" != "e" ]] && [[ "e$ip_address" != "e" ]]
    then
        # echo "mlan0 get ip"
        echo 1 > /sys/class/leds/wifi/brightness
        sleep 1
        echo 0 > /sys/class/leds/wifi/brightness
        sleep 1
	elif [ "e${wifi_status}" != "e" ]
    then
        # echo "wifi insert"
        echo 1 > /sys/class/leds/wifi/brightness
        sleep 5
    else
        # echo "wifi no insert"
        echo 0 > /sys/class/leds/wifi/brightness
        sleep 5
    fi
done
}

function cellular_monitor()
{
while true
do
    ip_address_4G=`ifconfig | grep -A 3 ppp0 | awk '/inet/ {print $2}' | cut -f2 -d ":"`
    ip_address_5G=`ifconfig | grep -A 3 wwan0 | awk '/inet/ {print $2}' | cut -f2 -d ":"`
    sim_modules_insert="Wireless"
    sim_status=`lsusb | grep "${sim_modules_insert}"`
    if [[ "e${sim_status}" != "e" ]] && [[ "e$ip_address_5G" != "e" || "e$ip_address_4G" != "e" ]]
    then
        # echo "get ip"
        echo 1 > /sys/class/leds/cellular/brightness
        sleep 1
        echo 0 > /sys/class/leds/cellular/brightness
        sleep 1
    elif  [[ "e${sim_status}" != "e" ]]
    then
        # echo " insert"
        echo 1 > /sys/class/leds/cellular/brightness
        sleep 5
    else
        # echo "no insert"
        echo 0 > /sys/class/leds/cellular/brightness
        sleep 5
    fi
done
}

if [ -e /sys/class/leds/status/brightness ]; then
	echo 1 > /sys/class/leds/status/brightness
fi

if [ -e /sys/class/leds/wifi/brightness ]; then
	wifi_monitor &
fi 

if [ -e /sys/class/leds/cellular/brightness ]; then
	cellular_monitor 
fi
