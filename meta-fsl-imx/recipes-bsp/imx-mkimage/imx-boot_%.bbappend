FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
TCMBINPATH := "${THISDIR}/files"

compile_mx8ulp:prepend() {
    cp ${TCMBINPATH}/imx8ulprom2620a1_m33_TCM_power_mode_switch_v0001.bin       ${BOOT_STAGING}/m33_image.bin
}
