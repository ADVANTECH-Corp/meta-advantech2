#!/bin/sh
stty -F /dev/ttyMSM1 speed 115200 -echo;
#cat /dev/ttyMSM1 &
while true
do
        echo "[Serial Port]" > /dev/ttyMSM1
        sleep 1
done

