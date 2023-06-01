#!/bin/bash
if [ $# != 2 ]; then
	cat <<-EOF
	
	Usage:
	    $0 {BT device's MAC} {sending file}

	EOF
	exit
fi

BTMAC=${1^^}
FILE=$2

if [[ ! $BTMAC =~ ^([0-9A-F]{2}:){5}([0-9A-F]{2})$ ]]; then
	echo "invalid MAC"
	exit
fi

if [ ! -f $FILE ]; then
	echo "file not found"
	exit
fi

if ! pidof bluetoothd &>/dev/null; then
	/usr/libexec/bluetooth/bluetoothd -C &
fi
hciconfig hci0 up

if ! echo -e "quit\r" | bluetoothctl | grep "$BTMAC" &>/dev/null; then
	echo "$1 not paired"
	exit
fi

bt_obexd_start.sh
. /tmp/dbus-session.out
hciconfig hci0 up
sleep 3

cat <<-EOF | expect
	set timeout 600
	spawn "obexctl"
	expect "# "
	sleep 2
	send "connect $BTMAC\r"
	expect "Connection successful"
	expect "# "
	send "send $FILE\r"
	expect "Status: complete"
	expect "# "
	send "quit\r"
EOF
echo -e "\n\n"
