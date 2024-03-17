#!/bin/sh

if [ -e "/tools/ADV_OVERLAY" ]
then
	cp /tools/dhcpd.conf /etc/dhcp/
	sync
	rm /tools/ADV_OVERLAY
	systemctl restart isc-dhcp-server.service
fi

#systemctl disable adv-overlay.service
sync
