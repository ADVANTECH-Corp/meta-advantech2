#!/bin/bash
hwclock -s; hwclock -r > /dev/null

F="/etc/boottimes"
TIMEOUT_CHECK=0
FAILED=0
boot_timeout=0
boot_count=0
boot_sec=`date +%s`
boot_previous_sec=0
time_cost=0
LEND=("" "FAIL!!")

[[ -f $F ]] && {
  [[ $1 != "" ]] && (( $1 > 0 )) && { TIMEOUT_CHECK=1; boot_timeout=$(($1)); }
  set - `head -n1 $F`
  boot_count=$1
  boot_previous_sec=$2
  time_cost=$((boot_sec - boot_previous_sec))
}
[[ $TIMEOUT_CHECK == 1 ]] && (( $boot_timeout < $time_cost )) && FAILED=1
((boot_count++))

echo "$boot_count $boot_sec" > $F
echo -e "\033[35m"\
"Boot Times:$boot_count, Seconds:$boot_sec, Cost:$time_cost ${LEND[$FAILED]}"\
"\033[0m"
