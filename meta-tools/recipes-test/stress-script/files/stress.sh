#!/bin/sh

THERMAL_ZONE0_TEMP="/sys/devices/virtual/thermal/thermal_zone0/temp"

echo "disabled" > /sys/devices/virtual/thermal/thermal_zone0/mode

/tools/log.sh &
memtester 500M &
stress -c 6
#/tools/uart.sh 5 &
#/tools/eth1.sh A &
#/tools/eth0.sh B &
#/tools/sd.sh mmcblk1 &
#/tools/usb.sh 3 &
#/tools/wifi.sh SSD PWD &
#/tools/cpu-gpu-vpu.sh &

#glmark2 --size 1280x720 --annotate --run-forever &
