FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
RM_WORK_EXCLUDE += "${PN}"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2021.04_5.10.72_2.2.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "ea6632e1d04a9e33a7312d7d804b4aa5fc7d04d1"

#do_deploy_append_mx6() {
#    install -d ${DEPLOYDIR}
#    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
#    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
#    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
#}
