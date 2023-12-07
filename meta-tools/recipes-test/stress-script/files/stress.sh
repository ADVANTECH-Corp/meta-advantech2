#!/bin/sh

THERMAL_ZONE0_TEMP="/sys/devices/virtual/thermal/thermal_zone0/temp"
THERMAL_ZONE1_TEMP="/sys/devices/virtual/thermal/thermal_zone1/temp"
CPU_FREQENCY="/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq"

echo "disabled" > /sys/devices/virtual/thermal/thermal_zone0/mode
echo "disabled" > /sys/devices/virtual/thermal/thermal_zone1/mode
echo "performance" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

if [ -n "$DISPLAY" ]; then
	[ -e ${THERMAL_ZONE0_TEMP} ] && \
	xterm -title thermal_zone0 -e watch -n 1 cat ${THERMAL_ZONE0_TEMP} &

	[ -e ${THERMAL_ZONE1_TEMP} ] && \
	xterm -title thermal_zone1 -e watch -n 1 cat ${THERMAL_ZONE1_TEMP} &

	[ -e ${CPU_FREQENCY} ] && \
	xterm -title cpu_freq -e watch -n 1 cat ${CPU_FREQENCY} &

	xterm -title top -e top &
fi

. /etc/profile.d/weston.sh
export DISPLAY=:0

/tools/play.sh &
/tools/gpu.sh &
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
