ADDON_FILES_DIR:="${THISDIR}/files"

M40_DEMOS_imx8qmrom7720a1 = "imx8qmrom7720a1_m4_0.bin"
M41_DEMOS_imx8qmrom7720a1 = "imx8qmrom7720a1_m4_1.bin"

do_deploy_append_imx8qmrom7720a1() {
    install ${ADDON_FILES_DIR}/${M40_DEMOS_imx8qmrom7720a1} ${DEPLOYDIR}/m4_0.bin
    install ${ADDON_FILES_DIR}/${M41_DEMOS_imx8qmrom7720a1} ${DEPLOYDIR}/m4_1.bin
}

