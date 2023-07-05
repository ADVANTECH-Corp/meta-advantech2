#! /bin/sh

while true
do
        Destination=`route -n | grep "wwan0" | awk '{print $1}' | awk 'NR==1'`
        if [ "$Destination" != "0.0.0.0" ] && [  -n "$Destination" ]
        then
                route add -net 0.0.0.0 netmask 0.0.0.0 metric 700 dev wwan0
                echo "add wwan0 default "
        fi
done

