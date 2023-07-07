FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2022.04_5.15.52_2.1.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "6b9ef85ef3beb591d9c2b90f87c196ebaf65d8ed"

#do_deploy_append_mx6() {
#    install -d ${DEPLOYDIR}
#    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
#    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
#    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
#}
