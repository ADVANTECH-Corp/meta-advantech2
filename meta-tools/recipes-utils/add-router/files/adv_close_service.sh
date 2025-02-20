#! /bin/sh

cp /tools/add-router/systemd-networkd-wait-online.service /lib/systemd/system/
sync

systemctl stop connman.service
systemctl disable connman.service
sync

#systemctl stop systemd-networkd-wait-online.service
#systemctl disable systemd-networkd-wait-online.service
sync

systemctl enable systemd-resolved.service
systemctl restart systemd-resolved.service
sync
sleep 1
rm /etc/resolv.conf
ln -s /etc/resolv-conf.systemd /etc/resolv.conf
sync

#rm -rf /lib/modules/6.6.23*/updates/
#rmmod mlan

systemctl disable adv_close_service.service
sync

