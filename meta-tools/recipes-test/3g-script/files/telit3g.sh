#!/bin/sh

PROGRAM="Telit 3G"

echo -en "\033[35m"
echo "[$PROGRAM] Set ECM mode"
echo -en "\033[0m"

echo AT#USBCFG=3 > /dev/ttyACM0
sleep 1

echo AT#REBOOT > /dev/ttyACM0
sleep 15

echo -en "\033[35m"
echo "[$PROGRAM] Connect network ... "
echo -en "\033[0m"

echo 'AT+CGDCONT=1,"IP","internet"' > /dev/ttyACM0
sleep 1

udhcpc -b -i wwan0

echo AT#ECM=1,0 > /dev/ttyACM0
sleep 20

echo -en "\033[35m"
echo "[$PROGRAM] Done! Please confirm IP address via ifconfig."
echo -en "\033[0m"

