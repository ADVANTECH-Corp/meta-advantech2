#!/bin/sh
#########################################################
#   description: wifi modprobe script
#   version:2023/03/03 by kuihong
########################################################

DIR=`dirname $0`

#海华wifi模组
ADV_AW_WIFI_NXP()
{
        wifi5_status=
        wifi6_status=
        ip_address=

        wifi5_status=`lspci -n |grep "1b4b:2b42"`
        if [ "e$wifi5_status" != "e" ]
        then
                e=`lsmod|grep moal_mxm6x17408_pcieuart |awk {'print$1'}`
                if [ -z "$e" ]
                then
                        modprobe mlan_mxm6x17408_pcieuart
                        modprobe moal_mxm6x17408_pcieuart drv_mode=1 ps_mode=2 auto_ds=2 cal_data_cfg=none cfg80211_wext=0xf fw_name=nxp/pcieuart8997_combo_v4_6x17408.bin
                        sleep 1
                fi
        fi

        wifi6_status=`lspci -n |grep "1b4b:2b44"`
        if [ "e$wifi6_status" != "e" ]
        then
                e=`lsmod|grep moal_mxm6x17408_pcieuart |awk {'print$1'}`
                if [ -z "$e" ]
                then
                        modprobe mlan_mxm6x17408_pcieuart
                        modprobe moal_mxm6x17408_pcieuart drv_mode=1 ps_mode=2 auto_ds=2 cfg80211_wext=0xf cal_data_cfg=none fw_name=nxp/pcieuart9098_combo_v1.bin host_mlme=1
                        sleep 1
                fi
        fi
}

ADV_AW_WIFI_NXP &
