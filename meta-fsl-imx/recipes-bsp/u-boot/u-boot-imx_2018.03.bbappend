FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "imx_v2018.03_4.14.98_2.0.0_ga"
UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx6.git;protocol=https;branch=${SRCBRANCH}"
SRCREV = "7a6ae5a89ba98ac563b43c581d2430bef69ad146"

do_deploy_append_mx6() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
}
