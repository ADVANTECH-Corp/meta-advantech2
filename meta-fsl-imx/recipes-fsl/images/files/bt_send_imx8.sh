#!/bin/bash
if [ $# != 2 ]; then
	cat <<-EOF
	
	Usage:
	    $0 {BT device's MAC} {sending file}

	EOF
	exit
fi
#test
BTMAC=${1^^}
FILE=$2




#bt_obexd_start.sh
. /tmp/dbus-session.out
sleep 3

cat <<-EOF | expect
	spawn "obexctl"
	expect "# "
	send "help\r"
	expect "# "
	send "connect $BTMAC\r"
	expect "Connection successful"
	expect "# "
	send "send $FILE\r"
	expect "Status: complete"
	expect "# "
	send "quit\r"
EOF
