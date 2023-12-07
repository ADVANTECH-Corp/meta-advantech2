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
    -f		FORCE_ENABLE

EOT
  exit $E
}

HEXV=""
case "$@" in
  ""|-h|--help) usage ;;
  -p) HEXV=0x40000000 ;;
  -j) HEXV=0x10000000 ;;
  -k) HEXV=0x20000000 ;;
  -n) HEXV=0x30000000 ;;
  -f) HEXV=0x50000000 ;;
  *) usage 1 ;;
esac
(( $DEBUG > 0 )) && { echo "HEXV=$HEXV"; exit 0; }

echo -1 > /sys/module/usbcore/parameters/autosuspend
for i in $(find /sys -name control | grep usb);do echo on > $i;echo "echo on > $i";done;
/unit_tests/memtool 0x5b130480=0xa0
/unit_tests/memtool 0x5b130490=0xa0
/unit_tests/memtool 0x5b130080=0x804
/unit_tests/memtool 0x5b130484=0x80000000
/unit_tests/memtool 0x5b130484=$HEXV
