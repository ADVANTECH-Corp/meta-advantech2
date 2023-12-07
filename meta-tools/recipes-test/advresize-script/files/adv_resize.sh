#!/bin/sh
DEV=`findmnt -n -o SOURCE / | cut -c 6-12`

start=$(cat /sys/block/"$DEV"/"$DEV"p2/start)
end=$(($start+$(cat /sys/block/"$DEV"/"$DEV"p2/size)))
newend=$(($(cat /sys/block/"$DEV"/size)-8))


if [ "$newend" -gt "$end" ];then
fdisk -u /dev/"$DEV" << EOF &>/dev/null
d
2
n
p
2
$start
$newend
w
EOF
	touch /forcefsck
	touch /flag
	sync
	exit 1
else
	systemctl disable adv_resize	
	
fi

if [ -f /flag ];then
	resize2fs /dev/"$DEV"p2
	rm /flag
	sync
	systemctl disable adv_resize	
fi

