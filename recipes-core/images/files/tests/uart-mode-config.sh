#!/bin/sh

if [ $# != 2 ];then
   echo "Usage:$0 ttyO3 rs232"
   echo "      $0 ttyO4 rs485"
   exit
fi

if [[ $1 != "ttyO3" ]] && [[ $1 != "ttyO4" ]];then
   echo "Only support ttyO3/ttyO4"
   exit
fi

if [[ $2 != "RS232" ]] && [[ $2 != "rs232" ]] && [[ $2 != "RS485" ]] && [[ $2 != "rs485" ]];then
   echo "Setting UART mode error"
   exit
fi

setting_mode=$2
typeset -l $setting_mode

CURR=${PWD}
if [ $1 == "ttyO3" ];then
    if [[ $2 == "rs232" ]] || [[ $2 == "RS232" ]];then
        echo 1 > /sys/class/gpio/GPIO-6/value
        echo 0 > /sys/class/gpio/GPIO-7/value
        echo 0 > /sys/class/gpio/GPIO-8/value
    elif [[ $2 == "rs485" ]] || [[ $2 == "RS485" ]];then
        echo 0 > /sys/class/gpio/GPIO-6/value
        echo 1 > /sys/class/gpio/GPIO-7/value
        echo 1 > /sys/class/gpio/GPIO-8/value
    fi

    cd /boot
    if [ -f "/boot/am335x-epcr3220a1.dtb" ];then
        rm am335x-epcr3220a1.dtb
    fi
    rs485_flag=`cat /sys/class/gpio/GPIO-10/value`
    if [[ $rs485_flag == "1" ]];then
        ln -s am335x-epcr3220a1-3${setting_mode}-4rs485.dtb am335x-epcr3220a1.dtb
    elif [[ $rs485_flag == "0" ]];then
        ln -s am335x-epcr3220a1-3${setting_mode}-4rs232.dtb am335x-epcr3220a1.dtb
    fi
fi

if [ $1 == "ttyO4" ];then
    if [[ $2 == "rs232" ]] || [[ $2 == "RS232" ]];then
        echo 1 > /sys/class/gpio/GPIO-9/value
        echo 0 > /sys/class/gpio/GPIO-10/value
        echo 0 > /sys/class/gpio/GPIO-11/value
    elif [[ $2 == "rs485" ]] || [[ $2 == "RS485" ]];then
        echo 0 > /sys/class/gpio/GPIO-9/value
        echo 1 > /sys/class/gpio/GPIO-10/value
        echo 1 > /sys/class/gpio/GPIO-11/value
    fi

    cd /boot
    if [ -f "/boot/am335x-epcr3220a1.dtb" ];then
        rm am335x-epcr3220a1.dtb
    fi
    rs485_flag=`cat /sys/class/gpio/GPIO-7/value`
    if [[ $rs485_flag == "1" ]];then
        ln -s am335x-epcr3220a1-3rs485-4${setting_mode}.dtb am335x-epcr3220a1.dtb
    elif [[ $rs485_flag == "0" ]];then
        ln -s am335x-epcr3220a1-3rs232-4${setting_mode}.dtb am335x-epcr3220a1.dtb
    fi
fi
sync
cd ${CURR}


