ADDON_FILES_DIR:="${THISDIR}/files"

M40_DEMOS_imx8qmrom7720a1_4g = "imx8qmrom7720a1_4g_m4_0.bin"
M41_DEMOS_imx8qmrom7720a1_4g = "imx8qmrom7720a1_4g_m4_1.bin"
SECO_FW_C0_imx8qxprom5620a1_2g = "mx8qxc0-ahab-container.img"

do_deploy_append_imx8qmrom7720a1_4g() {
    install ${ADDON_FILES_DIR}/${M40_DEMOS_imx8qmrom7720a1_4g} ${DEPLOYDIR}/m4_0.bin
    install ${ADDON_FILES_DIR}/${M41_DEMOS_imx8qmrom7720a1_4g} ${DEPLOYDIR}/m4_1.bin
}

do_deploy_append_imx8qxprom5620a1_2g() {
    install -m 0644 ${ADDON_FILES_DIR}/${SECO_FW_C0_imx8qxprom5620a1_2g} ${DEPLOYDIR}/mx8qx-ahab-container.img
}
