#!/bin/bash
R=`findmnt -e -n -o source /`
D=${R::-1}
P=${R: -1}
[[ ${D: -1} == p ]] && D=${D::-1}
parted $D -- resizepart $P 100% || exit 1
partprobe $D || exit 2
resize2fs $R || exit 3
