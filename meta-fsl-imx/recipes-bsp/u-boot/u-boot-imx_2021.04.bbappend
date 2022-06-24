FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "adv_v2021.04_5.10.35_2.0.0"
UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCREV = "1f5ed594d2dcceea0896908e16f1bb58bff94665"

do_deploy_append_mx6() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
}
