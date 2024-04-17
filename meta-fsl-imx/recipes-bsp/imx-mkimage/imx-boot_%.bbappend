FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
TCMBINPATH := "${THISDIR}/files"

SRC_URI:append:imx8mqrom5720a1 ="${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-add-imx8mq-rom5720a1-2G-support.patch', '', d)}"

compile_mx8ulp:prepend() {
    cp ${TCMBINPATH}/imx8ulprom2620a1_m33_TCM_sdk_2_14_0_v0001.bin       ${BOOT_STAGING}/m33_image.bin
}
compile_mx8m:prepend() {
    case ${MACHINE} in
    imx8mq*)
	cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${BOOT_STAGING}/imx8mq-evk.dtb
	;;
    imx8mm*)
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME}   ${BOOT_STAGING}/imx8mm-evk.dtb
        ;;
   esac
}
