IMAGE_INSTALL_append_mx6 += " ota-script "
IMAGE_INSTALL_append_mx6 += " python-paho-mqtt libxmu "

OTA_CONFIGS_DIR:="${THISDIR}/files"
CACHE_PARTITION = "/dev/disk/by-label/cache"

modify_fstab() {
	echo "${CACHE_PARTITION}      /cache               ext4       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

ROOTFS_POSTPROCESS_COMMAND += "modify_fstab"

