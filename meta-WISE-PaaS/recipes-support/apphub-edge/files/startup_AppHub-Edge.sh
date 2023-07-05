#!/bin/bash
#v2.0
sleep 10
TARGET_DIR=`cd "$(dirname "$0")"; pwd`
productName="AppHub-Edge"
## Environment
## diffrent platform has diffrent env value.

## setting for display manager's xauthority.
exportVar="/var/run/lightdm/root/:0"
if [ -a ${exportVar} ]; then
	echo "[INFO]lightdm is display manager."
	echo "XAUTHORITY=/var/run/lightdm/root/:0"
	export XAUTHORITY=$exportVar
else
	exportVar="/var/run/lxdm/lxdm-:0.auth"
	if [ -a ${exportVar} ]; then
		echo "[INFO]lxdm is display manager."
		echo "XAUTHORITY=/var/run/lxdm/lxdm-:0.auth"
		export XAUTHORITY=$exportVar
	else
		exportVar="/run/user/1000/gdm/Xauthority"
		if [ -a ${exportVar} ]; then
			echo "[INFO]gdm is display manager."
			echo "XAUTHORITY=/run/user/1000/gdm/Xauthority"
			export XAUTHORITY=$exportVar
		else
			echo "[Warning] No avaliable display manager."
		fi
	fi
fi

#for screenshot function
export DISPLAY=:0

## platform
## different platform to run different bin

cd $TARGET_DIR

key=`uname -m`
if [[ "$key" = "x86_64" ]]; then
	./${productName}
elif [[ "$key" = "arm" || "$key" = "armv7l" ]];then
	./${productName}-ARM
elif [[ "$key" = "aarch64_be"  ||  "$key" = "aarch64"  ||  "$key" = "armv8b"  ||  "$key" = "armv8l" ]];then
	./${productName}-ARM64
else
	echo "[Warning]Maybe Not Support."
fi

sleep 2


