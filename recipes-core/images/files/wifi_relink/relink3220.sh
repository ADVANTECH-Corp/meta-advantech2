#!/bin/sh

	
while true
do
	sleep 5
	#check mlan0 is ON
	mlan_status=`ifconfig |grep mlan0 | awk {'print $1'}`
	#echo "[ADV] $mlan_status"
	if [ "x$mlan_status" == "x" ];then
		echo "please waiting for mlan0 up..."
		ifconfig mlan0 up
	fi
	
	
	#check wifi is configured (if file wpa.conf exist)
	if [ ! -f "/etc/wifi/wpa.conf" ];then
		echo "Not find wifi config file"
		continue
	fi


	#check wifi is connect
	wifi_status=`wpa_cli -i mlan0 status |grep wpa_state |cut -d "=" -f2`
	ip_address=`wpa_cli -i mlan0 status  |grep ip_address |cut -d "=" -f2`
	gateway=`ip route show |grep "dev mlan0" |grep "default via" | awk {'print $3'}`
	if [[ "x$wifi_status" == "xCOMPLETED" ]] && [[ "x$ip_address" != "x" ]] && [[ "x$gateway" != "x" ]];then
		#echo "[ADV] wifi is connected"
		continue 
	else
		echo "please waitting for relink..."
		killall wpa_supplicant
		sleep 2
		wpa_supplicant -B Dwext -i mlan0 -c /etc/wifi/wpa.conf
		sleep 5

		udhcpc_pid_list=`ps -aux | grep udhcpc |grep mlan0 | awk {'print $2'}`
		if [ "x$udhcpc_pid_list" != "x" ];then
			for(( i=0;i<${#udhcpc_pid_list[@]};i++)) do
				kill ${udhcpc_pid_list[i]};
				echo  "[ADV] kill ${udhcpc_pid_list[i]}"
			done
		fi

		udhcpc -i mlan0
        
		continue
	fi

	echo "return is fall"
done


