#!/bin/sh

sleep 30
## power off the machine.
if [ -f /data/BurnIn/atx ]; then
    poweroff
else
    reboot
fi

