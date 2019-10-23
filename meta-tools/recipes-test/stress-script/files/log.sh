#!/bin/sh

PATH_THERMAL_ZONE0="/sys/class/thermal/thermal_zone0/temp"
PATH_THERMAL_ZONE1="/sys/class/thermal/thermal_zone1/temp"

PROJECT=`cat /proc/board | cut -c 1-8`
LOG_FILE="QAlab.log"
echo "Run For ${PROJECT}"
echo "Run For ${PROJECT}" >> ${LOG_FILE}

echo "Log start"
echo "Log start" >> ${LOG_FILE}
echo "-------------------------------------------------------------------------------------"
echo "-------------------------------------------------------------------------------------" | tee -a ${LOG_FILE}

i=0
while true
do
    i=$(($i+1))
    DATE=`date +%F-%T`
    echo "Loop $i at $DATE"
    [ -e ${PATH_THERMAL_ZONE0} ] && \
	TEMPERATURE0=`cat ${PATH_THERMAL_ZONE0}`
    [ -e ${PATH_THERMAL_ZONE1} ] && \
	TEMPERATURE1=`cat ${PATH_THERMAL_ZONE1}`
    TOP_LOG=`top -b -n 3 -d 1 |grep "KiB Swap" -B4 -A6`
    CPU_FREQUENCY=`cpufreq-info -f`

    #log temp
    echo "Loop $i at $DATE" | tee -a ${LOG_FILE}
    echo "$TOP_LOG" | tee -a ${LOG_FILE}
    echo "temperature 0:$TEMPERATURE0" | tee -a ${LOG_FILE}
    echo "temperature 1:$TEMPERATURE1" | tee -a ${LOG_FILE}
    echo "CPU Frequency:$CPU_FREQUENCY" | tee -a ${LOG_FILE}
    sleep 3
    sync
done
