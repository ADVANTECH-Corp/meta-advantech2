FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2023.04_6.1.22-2.0.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "157480bce0358d727ba99e570c013c4aa6797c02"


#EXTRA_OEMAKE += "-I${S}/usr/bin' "
#EXTRA_OEMAKE += "-I${S}/usr/bin' "
#EXTRA_OEMAKE += "ARCH=${ARCH}"
#EXTRA_OEMAKE += "KSRC=${STAGING_KERNEL_BUILDDIR}"

do_deploy:append:mx6-nxp-bsp() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
}
