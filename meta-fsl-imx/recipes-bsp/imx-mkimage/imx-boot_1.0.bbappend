
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-rom5721a1-1G-support.patch', '', d)}"
SRC_URI_append_imx8mqrom5720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-add-imx8mq-rom5720a1-2G-support.patch', '', d)}"

do_compile_prepend () {
    case ${MACHINE} in
    imx8mq*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${BOOT_STAGING}/imx8mq-evk.dtb
        ;;
    imx8mm*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${BOOT_STAGING}/imx8mm-evk.dtb
        ;;
    imx8mp*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${BOOT_STAGING}/imx8mp-evk.dtb
        ;;
    esac
}
do_compile_append () {
    case ${MACHINE} in
    imx8m*)
        rm ${BOOT_STAGING}/mkimage_uboot
        cp -f ${STAGING_DIR_NATIVE}${bindir}/mkimage            ${BOOT_STAGING}/mkimage_uboot
        ;;
    esac
}