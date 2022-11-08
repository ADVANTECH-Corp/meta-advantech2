#!/bin/sh

# Based off:
# https://github.com/RobertCNelson/boot-scripts/blob/master/boot/am335x_evm.sh

# Assume some defaults
sleep 15
SERIAL_NUMBER="1234BBBK5678"
PRODUCT="am335x_adv"
manufacturer="Advantech"

echo "SERIAL_NUMBER = ${SERIAL_NUMBER}"
echo "PRODUCT = ${PRODUCT}"

rootdrive=`mount | grep 'on / ' | awk {'print $1'} |  cut -c6-12`

mac_address="/proc/device-tree/ocp/ethernet@4a100000/slave@4a100300/mac-address"
[ -r "$mac_address" ] || exit 0

# Set the g_multi parameters
g_defaults="cdrom=0 stall=0 removable=1 nofua=1"

g_storage="file=/dev/${rootdrive}p1"

mod_flag=`lsmod |grep musb_am335x |awk {'print $1'}`
if [ x${mod_flag} == "x" ]; then
   modprobe musb_dsps
   modprobe musb_hdrc
   modprobe udc_core
   modprobe phy_am335x
   modprobe phy_generic
   modprobe phy_am335x_control
   modprobe pm33xx
   modprobe wkup_m3_ipc
   modprobe wkup_m3_rproc
   modprobe remoteproc
   modprobe omap_aes_driver
   modprobe crypto_engine
   modprobe omap_crypto
   modprobe omap_sham
   modprobe ti_emif_sram
   modprobe pruss_soc_bus
   modprobe spidev
   modprobe musb_am335x
   /lib/systemd/systemd-modules-load
   sleep 3
fi

mlan_flag=`ifconfig -a |grep mlan0 |awk {'print $1'}`
if [ x${mod_flag} == "x" ]; then
   mlan_driver_flag=`lsmod |grep sd8xxx |awk {'print $1'} |grep sd8xxx |awk {'print $1'}`
   if [ x${mlan_driver_flag} == "x" ]; then
      rmmod sd8xxx
   fi
   modprobe sd8xxx
fi

bt_flag=`hciconfig -a |grep hci0 |awk {'print $1'}`
if [ x${bt_flag} == "x" ]; then
   bt_driver_flag=`lsmod |grep bt8xxx |awk {'print $1'} `
   if [ x${bt_driver_flag} == "x" ]; then
      rmmod bt8xxx
   fi
   modprobe bt8xxx
fi


modprobe g_mass_storage ${g_storage} ${g_defaults}

