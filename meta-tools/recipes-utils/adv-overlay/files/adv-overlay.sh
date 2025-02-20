#!/bin/sh

OVERLAY_FLAG="/tools/adv-overlay/ADV_OVERLAY"

if [ -e "${OVERLAY_FLAG}" ]
then
	echo "adv-overlay.sh start"
##################START YOUR WORK#######################
# add timesync server , ntp.conf
	cp /tools/adv-overlay/ntp.conf /etc
	sync
	systemctl restart ntpd.service

###################END YOUR WORK########################
	sync
	rm "${OVERLAY_FLAG}"
	echo "adv-overlay.sh end"
fi

#systemctl disable adv-overlay.service

sync
