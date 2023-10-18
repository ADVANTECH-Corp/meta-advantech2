#!/bin/bash
UNPAIR=0
if [ "$1" == "-u" ]; then UNPAIR=1; shift 1; fi

if [ $# != 1 ]; then
	cat <<-EOF
	
	Usage:
	    $0 [-u] {BT device's MAC}

	EOF
	exit 1
fi

BTMAC=${1^^}

if [[ ! $BTMAC =~ ^([0-9A-F]{2}:){5}([0-9A-F]{2})$ ]]; then
	echo "invalid MAC"
	exit 1
fi

if ! pidof bluetoothd &>/dev/null; then
	/usr/libexec/bluetooth/bluetoothd -C &
fi
hciconfig hci0 up

if echo -e "quit\r" | bluetoothctl | grep "$BTMAC" &>/dev/null; then
	echo "$1 already paired"
	if [ $UNPAIR == 1 ]; then
		echo -e "remove $BTMAC\nquit\n" | bluetoothctl
		sleep 1
	else
		exit 1
	fi
fi
echo "pairing now..."
bt_obexd_start.sh
hciconfig hci0 up
. /tmp/dbus-session.out

cat <<-EOF | expect
	spawn "bluetoothctl"
	expect "# "
	send "scan on\r"
	expect "$BTMAC"
	send "scan off\r"
	send "agent NoInputNoOutput\r"
	send "default-agent\r"
	expect "Default agent request successful"
	send "pair $BTMAC\r"
	expect "Pairing successful"
	send "quit\r"
EOF

if echo -e "quit\r" | bluetoothctl | grep "$BTMAC" &>/dev/null; then
	echo -e "\n$1 paired done\n"
else
        echo -e "\n$1 not paired\n"
	exit 1
fi
