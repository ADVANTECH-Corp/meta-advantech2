#!/bin/bash

sleep 10

flag1=`systemctl list-units |grep systemd-logind |awk {'print $3'}`
if [ x$flag1 != "xactive" ];then
	echo "[ADV] systemd-logind boot fail" > /dev/ttyO0
fi
flag2=`systemctl list-units |grep weston |awk {'print $3'}`
if [ x$flag2 != "xactive" ];then
    echo "[ADV] weston boot fail" > /dev/ttyO0
fi
flag3=`systemctl list-units |grep serial-getty@ttyO0.service |awk {'print $3'}`
if [ x$flag3 != "xactive" ];then
    echo "[ADV] serial-getty@ttyO0.service boot fail" > /dev/ttyO0
fi


if [[ x$flag1 == "xactive" ]] && [[ x$flag2 == "xactive" ]] && [[ x$flag3 == "xactive" ]];then
    # disable WDT
    echo "[ADV] service boot success"  > /dev/ttyO0
    if [ -d "/sys/class/adv_bootprocess_class" ];then
        echo 1 > /sys/class/adv_bootprocess_class/adv_bootprocess_device/timer_flag
    fi
else
    echo "[ADV] service boot fail" > /dev/ttyO0
fi

