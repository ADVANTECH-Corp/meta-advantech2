# Arago TI SDK base image with test tools
# Suitable for initramfs

IMAGE_INSTALL_remove = " libxmu "
ADDON_TEST_FILES_DIR:="${THISDIR}/files/tests"
ADDON_3G_PROVIDER_DIR:="${THISDIR}/files/peers"
ADDON_MRVL_FW_DIR:="${THISDIR}/files/mrvl"

add_test_tools() {
	mkdir -p ${IMAGE_ROOTFS}/unit_tests
	install -m 0755 ${ADDON_TEST_FILES_DIR}/Loop_uart232 ${IMAGE_ROOTFS}/unit_tests
	install -m 0755 ${ADDON_TEST_FILES_DIR}/obexpushd ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${ADDON_TEST_FILES_DIR}/ussp-push ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${ADDON_TEST_FILES_DIR}/wwatb ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${ADDON_TEST_FILES_DIR}/uart-mode-config.sh ${IMAGE_ROOTFS}/usr/sbin
}

add_3G_provider() {
	install -m 0744 ${ADDON_3G_PROVIDER_DIR}/* ${IMAGE_ROOTFS}/etc/ppp/peers
}

add_mrvl_fw() {
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/mrvl
        install -m 0644 ${ADDON_MRVL_FW_DIR}/* ${IMAGE_ROOTFS}/lib/firmware/mrvl
}

ROOTFS_POSTPROCESS_COMMAND_append_ti33x = "add_test_tools;add_3G_provider;add_mrvl_fw;modify_fstab;"


