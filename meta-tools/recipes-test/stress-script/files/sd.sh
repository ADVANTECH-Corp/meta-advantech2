#!/bin/sh
SIZE=${SIZE:=1024}
DEV=$1

dd if=/dev/urandom of=/tmp/data_sd bs=1 count=$SIZE &>/dev/null

while true
do
	if [ "$#" -ne 1 ]; then
		echo "Please input 1 argument!"
		exit
	fi

        dd if=/dev/$DEV of=/tmp/data_sd_bak bs=1 count=$SIZE skip=4096 &>/dev/null
	if [ -e "/tmp/data_sd_bak" ]; then
                rm /tmp/data_sd_bak
                sync
        else
                echo "SD:/dev/$DEV Read fail"
		sleep 1
		continue
        fi

        dd if=/data_sd of=/dev/$DEV bs=1 seek=4096 &>/dev/null

	echo "SD:/dev/$DEV Read/Write Ok"

	sleep 1
done
