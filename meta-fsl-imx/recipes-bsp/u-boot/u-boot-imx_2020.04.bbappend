FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "adv_v2020.04_5.4.24_2.1.0"
UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCREV = "20b9af17d09016c8f30d2f5d519c25013cdf3f81"

do_deploy_append_mx6() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
}
