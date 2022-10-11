#!/bin/bash
UNPAIR=0
if [ "$1" == "-u" ]; then UNPAIR=1; shift 1; fi

if [ $# != 2 ]; then
	cat <<-EOF
	
	Usage:
	    $0 {BT device's MAC} {sending file}

	EOF
	exit 1
fi

DIR=`dirname $0`
BTMAC=${1^^}


echo "pairing now..."


bt_obexd_start.sh
sleep 1
bt_obexd_start.sh
. /tmp/dbus-session.out

cat <<-EOF | expect
	spawn "bluetoothctl"
	expect "# "
	send "power on\r"
	expect "Changing power on succeeded"
	send "discoverable on\r"
	expect "Changing discoverable on succeeded"
	send "pairable on\r"
	expect "Changing pairable on succeeded"
	send "remove $BTMAC\r"
	expect "Device"
	expect "# "
	send "scan on\r"
	expect "$BTMAC"
	expect "# "
	send "scan off\r"
	send "pair $BTMAC\r"
	expect "agent" {send "yes\r"}
	expect "Pairing successful"
	expect "# "
	send "connect $BTMAC\r"
	expect "yes"
	expect "# "
	send "quit\r"
EOF

$DIR/bt_send_imx8.sh $BTMAC $2
