IMAGE_INSTALL_append = " ota-script "
IMAGE_INSTALL_append = " python-paho-mqtt libxmu "

CACHE_PARTITION = "/dev/disk/by-label/cache"

modify_fstab() {
    echo "${CACHE_PARTITION}      /cache               ext4       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

add_automount_backlist() {
    echo /dev/mmcblk*p6  >> ${IMAGE_ROOTFS}/etc/udev/mount.blacklist
    echo /dev/mmcblk*p12 >> ${IMAGE_ROOTFS}/etc/udev/mount.blacklist
}

ROOTFS_POSTPROCESS_COMMAND += "modify_fstab; add_automount_backlist;"
