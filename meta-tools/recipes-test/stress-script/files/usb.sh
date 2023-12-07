#!/bin/sh

USBDEV=( "sda" "sdb" "sdc" "sdd" "sde" "sdf" )
USBNUM=$1
SIZE=${SIZE:=1024}

dd if=/dev/urandom of=/tmp/data_usb bs=1 count=$SIZE &>/dev/null

while true
do
	if [ "$#" -ne 1 ]; then
                echo "Please input 1 argument!"
                exit
        fi

	for ((N=0;N<$USBNUM;N++))
	do
		dd if=/dev/${USBDEV[N]} of=/tmp/data_${USBDEV[N]}_bak bs=1 count=$SIZE skip=4096 &>/dev/null
		if [ -e "/tmp/data_${USBDEV[N]}_bak" ]; then
			rm /tmp/data_${USBDEV[N]}_bak
			sync
		else
			echo "USB:/dev/${USBDEV[N]} Read fail"
			sleep 1
			continue
		fi
		
		dd if=/tmp/data_usb of=/dev/${USBDEV[N]} bs=1 seek=4096 &>/dev/null

		echo "USB:/dev/${USBDEV[N]} Read/Write OK"				

		sleep 1
	done
done
