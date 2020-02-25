IMAGE_INSTALL += " ota-script "

OTA_CONFIGS_DIR:="${THISDIR}/files"
CACHE_PARTITION = "/dev/disk/by-label/cache"

modify_fstab() {
	echo "${CACHE_PARTITION}      /cache               ext3       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

modify_do_update() {
	sed -i '54,64d' ${IMAGE_ROOTFS}/tools/do_update.sh
}

ROOTFS_POSTPROCESS_COMMAND_append = "  modify_fstab; modify_do_update;"
