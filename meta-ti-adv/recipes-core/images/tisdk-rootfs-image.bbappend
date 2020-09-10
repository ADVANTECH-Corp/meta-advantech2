# Arago TI SDK base image with test tools
# Suitable for initramfs

IMAGE_INSTALL_remove = " libxmu "
ADDON_TEST_FILES_DIR:="${THISDIR}/files/tests"
ADDON_3G_PROVIDER_DIR:="${THISDIR}/files/peers"
ADDON_MRVL_FW_DIR:="${THISDIR}/files/mrvl"
SERVICE_DIR:="${THISDIR}/files/service"
4G_TO_LAN_DIR:="${THISDIR}/files/4G_to_Lan"
LAN_TO_WIFI_DIR:="${THISDIR}/files/Lan_to_Wifi"


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

modify_modules_load_service() {
        install -m 0755 ${SERVICE_DIR}/systemd-modules-load.sh ${IMAGE_ROOTFS}/usr/bin
	rm ${IMAGE_ROOTFS}/lib/systemd/system/systemd-modules-load.service
        install -m 0644 ${SERVICE_DIR}/systemd-modules-load.service ${IMAGE_ROOTFS}/lib/systemd/system
}

add_4G_to_Lan() {
	install -m 0644 ${4G_TO_LAN_DIR}/4G-to-lan.service ${IMAGE_ROOTFS}/lib/systemd/system
	install -m 0755 ${4G_TO_LAN_DIR}/4G-to-lan ${IMAGE_ROOTFS}/usr/sbin
}

add_Lan_to_Wifi() {
	install -m 0644 ${LAN_TO_WIFI_DIR}/lan-to-wifi.service ${IMAGE_ROOTFS}/lib/systemd/system
	install -m 0755 ${LAN_TO_WIFI_DIR}/lan-to-wifi ${IMAGE_ROOTFS}/usr/sbin
	install -m 0755 ${LAN_TO_WIFI_DIR}/parse_udhcpd ${IMAGE_ROOTFS}/usr/sbin
}

ROOTFS_POSTPROCESS_COMMAND_append_ti33x = "add_test_tools;add_3G_provider;add_mrvl_fw;modify_fstab;modify_modules_load_service;add_4G_to_Lan;add_Lan_to_Wifi;"


