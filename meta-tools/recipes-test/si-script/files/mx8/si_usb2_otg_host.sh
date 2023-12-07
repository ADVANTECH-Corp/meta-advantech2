#!/bin/sh
function usage() {
  E=$(($1+0))
  (( E != 0 )) && echo -e "\n!!! Invalid parameter(s) !!!\n"

  cat <<-EOT

Usage:
  ${0##*/} [*]

    -h|--help	this help
    -p		Packet
    -j		J_STATE
    -k		K_STATE
    -n		SE0_NAK
    -R		RESET
    -S		SUSPEND
    -M		RESUME

EOT
  exit $E
}

HEXV=""
case "$@" in
""|-h|--help) usage ;;
-p) HEXV=0x18441205 ;;
-j) HEXV=0x18411205 ;;
-k) HEXV=0x18421205 ;;
-n) HEXV=0x18431205 ;;
-R) HEXV=0x18001305 ;;
-S) HEXV=0x18001285 ;;
-M) HEXV=0x18001245 ;;
*) usage 1 ;;
esac
(( $DEBUG > 0 )) && { echo "HEXV=$HEXV"; exit 0; }

echo -1 > /sys/module/usbcore/parameters/autosuspend
for i in $(find /sys -name control | grep usb);do echo on > $i;echo "echo on > $i";done
/unit_tests/memtool 0x5b0d0184=$HEXV
