#!/bin/sh

DEV=$1
IP_PREFIX="172.16.0"
echo "Start Eth0 Test"

if [ $DEV == "A" ]; then
  LOCAL_IP="${IP_PREFIX}.2"
  REMOTE_IP="${IP_PREFIX}.3"
else
  LOCAL_IP="${IP_PREFIX}.3"
  REMOTE_IP="${IP_PREFIX}.2"
fi

ifconfig eth0 ${LOCAL_IP}
ping ${REMOTE_IP} -I ${LOCAL_IP} &

