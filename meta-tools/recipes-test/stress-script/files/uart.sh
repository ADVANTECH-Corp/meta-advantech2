#!/bin/sh

TIMEOUT=$1
echo "Start UART Test : sleep $TIMEOUT sec"

stty -F /dev/ttyLP1 -echo -onlcr 115200

cat /dev/ttyLP1 &

while [ 1 ]; do
  echo "COM0 OK" > /dev/ttyLP1
  sleep $TIMEOUT
done
