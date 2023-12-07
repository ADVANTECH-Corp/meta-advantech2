#!/bin/sh
OPK=`cat /proc/sys/kernel/printk`
echo "0 0 0 0" > /proc/sys/kernel/printk
MODETEST=`modetest -c`
echo "$OPK" > /proc/sys/kernel/printk

N=( $(ls /sys/class/drm/card0-* -d | sed "s_/sys/class/drm/card0-__") )
for (( i=0; i<${#N[@]}; i++)); do
  ID=( $(grep "${N[$i]}" <<< "$MODETEST" | cut -f1) )
#  echo "ID=$ID #=${#ID[@]}"
  L=`sed -n "/^$ID/=" <<< "$MODETEST"`
#  echo $L
  sed "$L"',$!d; 1,/modes:/d; /name/d; /props:/,$d' <<< "$MODETEST"| cut -d' ' -f3-4 | sed "s/ /-/; s/\(.*\)/${ID}:\1/"
done
