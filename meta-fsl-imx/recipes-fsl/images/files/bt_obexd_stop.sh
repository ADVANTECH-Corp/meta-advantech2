#!/bin/sh
if [[ $0 != "-sh" ]]; then
   echo -e "\nUsing source instead of executing\n"
   exit 1
fi

if pidof obexd > /dev/null; then killall obexd; fi
if [ ! -z $DBUS_SESSION_BUS_PID ]; then kill $DBUS_SESSION_BUS_PID; fi
unset DBUS_SESSION_BUS_PID
unset DBUS_SESSION_BUS_ADDRESS
killall bluetoothd
/usr/libexec/bluetooth/bluetoothd -C &
if [ -e /tmp/dbus-session.out ]; then rm /tmp/dbus-session.out; fi
