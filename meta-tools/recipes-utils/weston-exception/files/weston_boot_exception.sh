#!/bin/sh
HOSTNAME=`hostname`
TRYSECONDS=60

if [ $HOSTNAME == "imx8ulprom2620a1" ]
then

	for ((N=0;N<$TRYSECONDS;N++))
	do
		PCRUNSTB_CNT=$((`dmesg| grep unstable | wc -l`))

		if [ $PCRUNSTB_CNT -eq 10 ] || [ $PCRUNSTB_CNT -gt 10 ]; then
			sleep 5
			service weston restart
			exit
		fi

		sleep 1
	done

fi
