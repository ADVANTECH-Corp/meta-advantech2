# Arago TI SDK base image with test tools
# Suitable for initramfs

IMAGE_INSTALL += " ota-script "
IMAGE_INSTALL_remove = " libxmu "
OTA_CONFIGS_DIR:="${THISDIR}/files"
CACHE_PARTITION = "/dev/disk/by-label/cache"

ADDON_TEST_FILES_DIR:="${THISDIR}/files/tests"
ADDON_3G_PROVIDER_DIR:="${THISDIR}/files/peers"
ADDON_MRVL_FW_DIR:="${THISDIR}/files/mrvl"

add_test_tools() {
	mkdir -p ${IMAGE_ROOTFS}/unit_tests
	install -m 0755 ${ADDON_TEST_FILES_DIR}/Loop_uart232 ${IMAGE_ROOTFS}/unit_tests
	install -m 0755 ${ADDON_TEST_FILES_DIR}/obexpushd ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${ADDON_TEST_FILES_DIR}/ussp-push ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${ADDON_TEST_FILES_DIR}/wwatb ${IMAGE_ROOTFS}/usr/sbin
}

add_3G_provider() {
	install -m 0744 ${ADDON_3G_PROVIDER_DIR}/* ${IMAGE_ROOTFS}/etc/ppp/peers
}

add_mrvl_fw() {
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/mrvl
        install -m 0644 ${ADDON_MRVL_FW_DIR}/* ${IMAGE_ROOTFS}/lib/firmware/mrvl
}

modify_fstab() {
        echo "${CACHE_PARTITION}      /cache               ext3       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

modify_do_update() {
        sed -i '54,64d' ${IMAGE_ROOTFS}/tools/do_update.sh
}

ROOTFS_POSTPROCESS_COMMAND_append_ti33x = "add_test_tools;add_3G_provider;add_mrvl_fw;modify_fstab; modify_do_update;"


