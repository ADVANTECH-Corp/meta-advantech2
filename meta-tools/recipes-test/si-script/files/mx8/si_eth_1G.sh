#!/bin/sh
[[ $1 != "" ]] && DEV=$1 || DEV=eth0
mdio-tool w $DEV 0x1d 0x000b
mdio-tool w $DEV 0x1e 0x0009
mdio-tool w $DEV 0x00 0x0140
mdio-tool w $DEV 0x09 0x2200
