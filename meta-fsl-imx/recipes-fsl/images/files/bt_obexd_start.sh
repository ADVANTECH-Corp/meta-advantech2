#!/bin/sh
if [ -f /tmp/dbus-session.out ]; then 
   . /tmp/dbus-session.out
   if ! grep dbus-daemon /proc/$DBUS_SESSION_BUS_PID/cmdline &>/dev/null; then
      DBUS_SESSION_BUS_PID=""
   fi
else
   DBUS_SESSION_BUS_PID=""
fi
if pidof obexd &>/dev/null; then killall obexd; fi

if [ "$DBUS_SESSION_BUS_PID" == "" ]; then
   eval `dbus-launch --sh-syntax | tee /tmp/dbus-session.out`
   echo "D-Bus per-session daemon address is: $DBUS_SESSION_BUS_ADDRESS"
fi
/usr/libexec/bluetooth/obexd &
killall bluetoothd
/usr/libexec/bluetooth/bluetoothd -C &
