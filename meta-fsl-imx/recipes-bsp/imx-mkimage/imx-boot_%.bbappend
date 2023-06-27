FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
TCMBINPATH := "${THISDIR}/files"

SRC_URI:append:imx8mmrom5721a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', '', d)}"

compile_mx8ulp:prepend() {
    cp ${TCMBINPATH}/imx8ulprom2620a1_m33_TCM_power_mode_switch_v0002.bin       ${BOOT_STAGING}/m33_image.bin
}
