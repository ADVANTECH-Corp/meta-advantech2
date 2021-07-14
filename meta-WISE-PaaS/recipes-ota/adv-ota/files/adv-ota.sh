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

CACHE_ROOT="/cache"
COMMAND_FILE="/cache/recovery/command"
INTENT_FILE="/cache/recovery/intent"
LAST_INSTALL_FILE="/cache/recovery/last_install"

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

    cd ${CACHE_ROOT}
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

    DEV_NODE=`readlink ${OUT_FILE}`

    printMsg "dd if=${IN_FILE} of=${OUT_FILE} ..."
    unzip -p $PACKAGE_FILE ${UPDATE_DIR}/${IN_FILE} | dd of=${OUT_FILE} bs=1M
    [ "$?" -ne 0 ] && exitRecovery "Err: update ${IN_FILE} failed!" true
    sync; sync

    # Re-assign labels
    if [ -z "${OUT_FILE##*$BOOT_LABEL*}" ]; then
        e2label $DISK_DIR/$DEV_NODE $BOOT_LABEL
        echo "e2label $DISK_DIR/$DEV_NODE $BOOT_LABEL"
    elif [ -z "${OUT_FILE##*$ROOTFS_LABEL*}" ]; then
        e2label $DISK_DIR/$DEV_NODE $ROOTFS_LABEL
        echo "e2label $DISK_DIR/$DEV_NODE $ROOTFS_LABEL"
    fi
    sleep 2

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
    IMAGE_ML=`grep update-module $UPDATE_SCRIPT | cut -d ',' -f 2`

    BOOT_TYPE="zImage"
    if [ -z ${IMAGE_DTB} ] ; then
        BOOT_HEADER=`unzip -p $PACKAGE_FILE ${UPDATE_DIR}/${IMAGE_BT} | hexdump -C -n 16 | grep ANDROID | cut -d '|' -f 2`
        if [ ! -z ${BOOT_HEADER} ] ; then
            BOOT_TYPE="boot"
        fi
    fi

    printMsg "Update boot partition (${BOOT_TYPE}) ..."
    if [ -e ${DISK_BT} ] ; then
        case $BOOT_TYPE in
        "zImage")
            umount $DISK_BT
            mount $DISK_BT /mnt/
            [ "$?" -ne 0 ] && exitRecovery "Err: 'mount' command failed!"
            if [ -n ${IMAGE_BT} ]; then
                unzip -o $PACKAGE_FILE ${UPDATE_DIR}/${IMAGE_BT}
                [ "$?" -ne 0 ] && exitRecovery "Err: update ${IMAGE_BT} failed!" true
                mv ${UPDATE_DIR}/${IMAGE_BT} /mnt/
            fi
            if [ -n ${IMAGE_DTB} ]; then
                unzip -o $PACKAGE_FILE ${UPDATE_DIR}/${IMAGE_DTB}
                [ "$?" -ne 0 ] && exitRecovery "Err: update ${IMAGE_DTB} failed!" true
                mv ${UPDATE_DIR}/${IMAGE_DTB} /mnt/
            fi
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

    printMsg "Update kernel modules ..."
    if [ -e ${DISK_RF} ] ; then
        umount $DISK_RF
        mount $DISK_RF /mnt/
        [ "$?" -ne 0 ] && exitRecovery "Err: 'mount' command failed!"
        if [ -n ${IMAGE_ML} ]; then
            unzip -p $PACKAGE_FILE ${UPDATE_DIR}/${IMAGE_ML} | tar zxf - -C ./
            [ "$?" -ne 0 ] && exitRecovery "Err: update ${IMAGE_ML} failed!" true
            ML_VERSION=`ls ./lib/modules/`
            rm -rf /mnt/lib/modules/*.old
            mv /mnt/lib/modules/${ML_VERSION} /mnt/lib/modules/${ML_VERSION}.old
            mv ./lib/modules/${ML_VERSION} /mnt/lib/modules/
            chroot /mnt << EOF
                depmod -a ${ML_VERSION}
                chown -R root:root lib/modules/${ML_VERSION}/
                exit
EOF
        fi
        umount /mnt
        printMsg "Update done!"
    else
        exitRecovery "Err: Cannot find rootfs partition in ${DISK_RF}"
    fi
}

updateRootfs()
{
    IMAGE_RF=`grep update-rootfs $UPDATE_SCRIPT | cut -d ',' -f 2`

    printMsg "Update rootfs partition ..."
    if [ -e ${DISK_RF} ] ; then
        umount ${DISK_RF}
        # Backup kernel module
        mount $DISK_RF /mnt/
        cp -a /mnt/lib/modules .modules
        umount /mnt
        # Update Rootfs
        doUpdate ${IMAGE_RF} ${DISK_RF}
        e2fsck -f -y ${DISK_RF}
        resize2fs ${DISK_RF}
        # Restore kernel module
        mount $DISK_RF /mnt/
        rm -rf /mnt/lib/modules
        mv .modules /mnt/lib/modules
        umount /mnt
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
if [ -e /dev/disk/by-partlabel/misc ] ; then
    DISK_DIR="/dev/disk/by-partlabel"
elif [ -e /dev/disk/by-label/misc ] ; then
    DISK_DIR="/dev/disk/by-label"
else
    exitRecovery "Err: cannot find valid /dev/disk/by-partlabel or /dev/disk/by-label" true
fi
DISK_BT="${DISK_DIR}/${BOOT_LABEL}"
DISK_RF="${DISK_DIR}/${ROOTFS_LABEL}"

if [ ! -e ${PACKAGE_FILE} ] ; then
    exitRecovery "Err: ${PACKAGE_FILE} does not exist!"
fi

printMsg "Unzip script from $PACKAGE_FILE ..."
unzip -o $PACKAGE_FILE ${UPDATE_DIR}/${UPDATE_SCRIPT} -d $CACHE_ROOT
cd ${CACHE_ROOT}/${UPDATE_DIR}
if [ ! -e ${UPDATE_SCRIPT} ] ; then
    exitRecovery "Err: ${UPDATE_SCRIPT} does not exist in ${PACKAGE_FILE}"
fi

IMAGE_LIST=`cut $UPDATE_SCRIPT -d ',' -f 2`
for IMAGE in $IMAGE_LIST ; do
    #if [ ! -e $IMAGE ] ; then
    #    exitRecovery "Err: ${IMAGE} listed in ${UPDATE_SCRIPT} does not exist!"
    #fi

    MD5_P=`grep $IMAGE $UPDATE_SCRIPT | cut -d ',' -f 3`
    MD5_Q=`unzip -p $PACKAGE_FILE ${UPDATE_DIR}/$IMAGE | md5sum -b | cut -d ' ' -f 1`
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
    "update-module")
        OTA_CMD_ML="true"
        ;;
    "update-rootfs")
        updateRootfs
        ;;
    *)
        printMsg "Warning: ${OTA_CMD} is not supported!"
        ;;
    esac
done

if [ ! -z ${OTA_CMD_KL} ] || [ ! -z ${OTA_CMD_DTB} ] || [ ! -z ${OTA_CMD_ML} ] ; then
    updateBoot
fi

# [4] Finish recovery
echo $PACKAGE_FILE > $LAST_INSTALL_FILE
exitRecovery "OK"

