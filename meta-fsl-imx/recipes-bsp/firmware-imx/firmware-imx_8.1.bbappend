ADDON_FILES_DIR:="${THISDIR}/files"

M40_DEMOS_imx8qmrom7720a1 = "imx8qmrom7720a1_m4_0.bin"
M41_DEMOS_imx8qmrom7720a1 = "imx8qmrom7720a1_m4_1.bin"
SECO_FW_C0_imx8qxprom5620a1 = "mx8qxc0-ahab-container.img"
SECO_FW_C0_imx8qxprom3620a1 = "mx8qxc0-ahab-container.img"

do_deploy_append_imx8qmrom7720a1() {
    install ${ADDON_FILES_DIR}/${M40_DEMOS_imx8qmrom7720a1} ${DEPLOYDIR}/m4_0.bin
    install ${ADDON_FILES_DIR}/${M41_DEMOS_imx8qmrom7720a1} ${DEPLOYDIR}/m4_1.bin
}

do_deploy_append_imx8qxprom5620a1() {
    install -m 0644 ${ADDON_FILES_DIR}/${SECO_FW_C0_imx8qxprom5620a1} ${DEPLOYDIR}/mx8qx-ahab-container.img
}

do_deploy_append_imx8qxprom3620a1() {
    install -m 0644 ${ADDON_FILES_DIR}/${SECO_FW_C0_imx8qxprom3620a1} ${DEPLOYDIR}/mx8qx-ahab-container.img
}
