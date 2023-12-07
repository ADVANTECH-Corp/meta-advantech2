#!/bin/sh

# Prepare for AT cmd
stty -F /dev/ttyUSB2 raw -echo
cat /dev/ttyUSB2 &

# Check System mode (WCDMA or LTE) and PS state (Attached)
echo -ne 'at!gstatus?\r\n' > /dev/ttyUSB2

# Show APN setting
echo -ne 'at+CGDCONT?\r\n' > /dev/ttyUSB2

# Activate data connection and get IP address
#  AT!SCACT=<state>,<pid>
#    state=1/0 means Act/Deactivate
#    pid=1~16  (1: All network except Verizon, 3: Verizon)
echo -ne 'at!scact=1,1\r\n' > /dev/ttyUSB2

