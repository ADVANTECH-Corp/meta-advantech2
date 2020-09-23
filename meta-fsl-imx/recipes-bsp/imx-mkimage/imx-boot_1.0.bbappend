
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"


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
    imx8mm*)
        rm ${BOOT_STAGING}/mkimage_uboot
        cp -f ${STAGING_DIR_NATIVE}${bindir}/mkimage            ${BOOT_STAGING}/mkimage_uboot
        ;;
    esac
}
