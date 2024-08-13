#!/bin/sh

OVERLAY_FLAG="/tools/adv-overlay/ADV_OVERLAY"

if [ -e "${OVERLAY_FLAG}" ]
then
	echo "adv-overlay.sh start"
##################START YOUR WORK#######################

# fix wifi modeproe issue ,(rm -rf /lib/moduels/xxx/extra)
	M_NAME=`uname -a | awk {print'$3'}`
	[ -e /lib/modules/$M_NAME ] && echo "/lib/modules/$M_NAME File exists"
	[ -e /lib/modules/$M_NAME/extra ]  && echo "/lib/modules/$M_NAME/extra File exists , start to remove"
	[ -e /lib/modules/$M_NAME/extra ]  && rm -rf /lib/modules/$M_NAME/extra
	sync

# add timesync server , ntp.conf
	cp /tools/adv-overlay/ntp.conf /etc
	sync
	systemctl restart ntpd.service

###################END YOUR WORK########################
	sync
	rm "${OVERLAY_FLAG}"
	echo "adv-overlay.sh end"
fi

################### every times runing ###################
hwclock -w


#systemctl disable adv-overlay.service

sync
