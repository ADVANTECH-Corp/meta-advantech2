#!/bin/sh
function usage() {
  E=$(($1+0))
  (( E != 0 )) && echo -e "\n!!! Invalid parameter(s) !!!\n"

  cat <<-EOT
Usage:
  ${0##*/} [*]
    -h|--help	this help
    -p		Set Link is in the Compliance Mode State

EOT
  exit $E
}

HEXV=""
case "$@" in
  ""|-h|--help) usage ;;
  -p) HEXV=0x0A000340 ;;
  *) usage 1 ;;
esac
(( $DEBUG > 0 )) && { echo "HEXV=$HEXV"; exit 0; }

echo -1 > /sys/module/usbcore/parameters/autosuspend
for i in $(find /sys -name control | grep usb);do echo on > $i;echo "echo on > $i";done;
/unit_tests/memtool 0x5b130490=$HEXV
