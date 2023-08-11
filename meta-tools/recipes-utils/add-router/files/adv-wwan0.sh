#! /bin/sh


while true
do
        sleep 2
        if [ -f "/proc/sys/net/ipv4/conf/wwan0/rp_filter" ]
        then
                if  [  `cat "/proc/sys/net/ipv4/conf/wwan0/rp_filter"` == 1 ]
                then
                        echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
                        echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter
                        echo 0 > /proc/sys/net/ipv4/conf/default/rp_filter
                        echo 0 > /proc/sys/net/ipv4/conf/wwan0/rp_filter
                fi
                break
        fi
done

while true
do
        Destination=`route -n | grep "wwan0" | awk '{print $1}' | awk 'NR==1'`
        if [ "$Destination" != "0.0.0.0" ] && [  -n "$Destination" ]
        then
                route add -net 0.0.0.0 netmask 0.0.0.0 metric 700 dev wwan0
                echo "add wwan0 default "
        fi
	sleep 2
done

