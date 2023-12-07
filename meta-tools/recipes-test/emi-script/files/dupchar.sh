#!/bin/sh
i=0
while true
do
        i=$(($i+1))
        echo -n H > /dev/tty1
        usleep 100
        if [ $i == 10000 ];then
                echo `busybox clear` > /dev/tty1
                i=0
        fi
done

