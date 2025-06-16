#! /bin/sh

systemctl stop connman.service
systemctl disable connman.service
sync

systemctl enable systemd-resolved.service
systemctl restart systemd-resolved.service
sync

sleep 0.2
rm /etc/resolv.conf
# ln -s /etc/resolv-conf.systemd /etc/resolv.conf
ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
sync


# disable adv_close_service
systemctl disable adv_close_service.service
sync

