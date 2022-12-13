FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "adv_v2020.04_5.4.70_2.3.0"
UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCREV = "f07f42bd3628da66d72cd845c0d06844c844d79d"

do_deploy_append_mx6() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
}
