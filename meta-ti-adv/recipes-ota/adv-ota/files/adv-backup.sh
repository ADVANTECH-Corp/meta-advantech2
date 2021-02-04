#!/bin/bash

usage()
{
    cat << EOF
Usage: `basename $0`

A shell script for OTA update procedure in recovery image

  -h    Show this help
EOF
    exit 1;
}

while getopts "h" o; do
    case "${o}" in
    h)
        usage
        ;;
    esac
done

BACKUP_ROOT="/backup"
COMMAND_FILE="/backup/recovery/command"
INTENT_FILE="/backup/recovery/intent"
LAST_INSTALL_FILE="/backup/recovery/last_install"

UPDATE_DIR="ota-update"
UPDATE_SCRIPT="updater-script"

BOOT_LABEL="boot"
ROOTFS_LABEL="rootfs"
MISC_LABEL="misc"

# ===========
#  Functions
# ===========
printMsg()
{
    echo "[OTA] $1"
}

cleanBCB()
{
    printMsg "Cleaning BCB ..."
    MISC_DEV="${DISK_DIR}/${MISC_LABEL}"
    if [ -e ${MISC_DEV} ] ; then
        dd if=/dev/zero of=${MISC_DEV} bs=1 count=32; sync
        printMsg "BCB is clear!"
    else
        printMsg "Err: Cannot find misc partition!"
        exit 1;
    fi
}

exitRecovery()
{
    RETURN_LOG="$1"
    NOT_CLEAN="$2"

    cd ${BACKUP_ROOT}
    rm $PACKAGE_FILE
    rm -rf $UPDATE_DIR

    echo "$RETURN_LOG" > $INTENT_FILE
    printMsg "$RETURN_LOG"

    if [ -z $NOT_CLEAN ] ; then
        cleanBCB
	rm -rf $PACKAGE_FILE 
        printMsg "Going to reboot ..."
        sync; sync
        /tools/adv-reboot
    fi

    exit 1;
}

doUpdate()
{
    IN_FILE=$1
    OUT_FILE=$2

    printMsg "tar -xJf ${IN_FILE} -C ${OUT_FILE} ..."
    tar -xJf ${IN_FILE} -C ${OUT_FILE}
    [ "$?" -ne 0 ] && exitRecovery "Err: 'tar' command failed!" true
    sync
    printMsg "Update done!"
}

updateBootloader()
{
    printMsg "Warning: ${OTA_CMD} does not support yet!"
}

updateBoot()
{
    IMAGE_BT=`grep update-kernel $UPDATE_SCRIPT | cut -d ',' -f 2`
    IMAGE_DTB=`grep update-dtb $UPDATE_SCRIPT | cut -d ',' -f 2`
    DISK_BT="${DISK_DIR}/${ROOTFS_LABEL}"

    BOOT_TYPE="zImage"
    if [ -z ${IMAGE_DTB} ] ; then
        BOOT_HEADER=`hexdump -C ${IMAGE_BT} -n 16 | grep ANDROID | cut -d '|' -f 2`
        if [ ! -z ${BOOT_HEADER} ] ; then
            BOOT_TYPE="boot"
        fi
    fi

    printMsg "Update boot partition (${BOOT_TYPE}) ..."
    if [ -e ${DISK_BT} ] ; then
        case $BOOT_TYPE in
        "zImage")
            mount $DISK_BT /mnt/
            [ "$?" -ne 0 ] && exitRecovery "Err: 'mount' command failed!"
            #rm /mnt/*
            cp ${IMAGE_BT} ${IMAGE_DTB} "/mnt/${BOOT_LABEL}"
            [ "$?" -ne 0 ] && exitRecovery "Err: 'cp' command failed!" true
            umount /mnt
            printMsg "Update done!"
            ;;
        "boot")
            doUpdate ${IMAGE_BT} ${DISK_BT}
            ;;
        esac
    else
        exitRecovery "Err: Cannot find boot partition in ${DISK_BT}"
    fi
}

updateRootfs()
{
    IMAGE_RF=`grep update-rootfs $UPDATE_SCRIPT | cut -d ',' -f 2`
    DISK_RF="${DISK_DIR}/${ROOTFS_LABEL}"

    printMsg "Update rootfs partition ..."
    if [ -e ${DISK_RF} ] ; then
	umount ${DISK_RF}
	/sbin/mkfs.ext3 -L "${ROOTFS_LABEL}" ${DISK_RF}
	sync
	mkdir -p /${ROOTFS_LABEL}
	sync
        mount ${DISK_RF} /${ROOTFS_LABEL}
        doUpdate ${IMAGE_RF} /${ROOTFS_LABEL}
	touch /${ROOTFS_LABEL}/test
	sync;sync;sync;sync;sync;sync;sync;sync
	sleep 20
	umount /${ROOTFS_LABEL}
	rm -rf /${ROOTFS_LABEL}
	sync
    else
        exitRecovery "Err: Cannot find rootfs partition in ${DISK_RF}"
    fi
}

# ===========
#    Main
# ===========
# [1] Read recovery commands
printMsg "Read recovery commands ..."
if [ -e ${COMMAND_FILE} ] ; then
    RECOVERY_CMD_LIST=`cut $COMMAND_FILE -d '=' -f 1 | cut -b 3-`
    for RECOVERY_CMD in $RECOVERY_CMD_LIST ; do
        case $RECOVERY_CMD in
        "update_package")
            PACKAGE_FILE=`grep $RECOVERY_CMD $COMMAND_FILE | cut -d '=' -f 2`
            ;;
        *)
            printMsg "Err: Command: ${RECOVERY_CMD} is not supported!"
            ;;
        esac
    done
else
    # If no recovery command is found, we just exit and go to shell in recovery mode.
    printMsg "Warning: Cannot find ${COMMAND_FILE}"
    exit 0;
fi

# [2] Check OTA package
printMsg "Check OTA package ..."
if [ -e /dev/disk/by-partlabel ] ; then
    DISK_DIR="/dev/disk/by-partlabel"
elif [ -e /dev/disk/by-label ] ; then
    DISK_DIR="/dev/disk/by-label"
else
    exitRecovery "Err: cannot find /dev/disk/by-partlabel or /dev/disk/by-label" true
fi

if [ ! -e ${PACKAGE_FILE} ] ; then
    exitRecovery "Err: ${PACKAGE_FILE} does not exist!"
fi

printMsg "Unzip $PACKAGE_FILE ..."
unzip -o $PACKAGE_FILE -d $BACKUP_ROOT
cd ${BACKUP_ROOT}/${UPDATE_DIR}
if [ ! -e ${UPDATE_SCRIPT} ] ; then
    exitRecovery "Err: ${UPDATE_SCRIPT} does not exist in ${PACKAGE_FILE}"
fi

IMAGE_LIST=`cut $UPDATE_SCRIPT -d ',' -f 2`
for IMAGE in $IMAGE_LIST ; do
    if [ ! -e $IMAGE ] ; then
        exitRecovery "Err: ${IMAGE} listed in ${UPDATE_SCRIPT} does not exist!"
    fi

    MD5_P=`grep $IMAGE $UPDATE_SCRIPT | cut -d ',' -f 3`
    MD5_Q=`md5sum -b $IMAGE | cut -d ' ' -f 1`
    if [ $MD5_P != $MD5_Q ] ; then
        exitRecovery "Err: MD5 of ${IMAGE} does not match!"
    fi
done

# [3] Update images
printMsg "Parse $UPDATE_SCRIPT in $PACKAGE_FILE ..."
OTA_CMD_LIST=`cut $UPDATE_SCRIPT -d ',' -f 1`
for OTA_CMD in $OTA_CMD_LIST ; do
    case $OTA_CMD in
    "update-bootloader")
        updateBootloader
        ;;
    "update-kernel")
        OTA_CMD_KL="true"
        ;;
    "update-dtb")
        OTA_CMD_DTB="true"
        ;;
    "update-rootfs")
        updateRootfs
        ;;
    *)
        printMsg "Warning: ${OTA_CMD} is not supported!"
        ;;
    esac
done

if [ ! -z ${OTA_CMD_KL} ] || [ ! -z ${OTA_CMD_DTB} ] ; then
    updateBoot
fi

# [4] Finish recovery
echo $PACKAGE_FILE > $LAST_INSTALL_FILE
exitRecovery "OK"

