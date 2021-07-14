
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-rom5721a1-1G-support.patch', '', d)}"

do_compile_prepend () {
    case ${MACHINE} in
    imx8mq*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${S}/${SOC_DIR}/fsl-imx8mq-evk.dtb
        ;;
    imx8mm*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${S}/${SOC_DIR}/fsl-imx8mm-evk.dtb
        ;;
    esac
}
