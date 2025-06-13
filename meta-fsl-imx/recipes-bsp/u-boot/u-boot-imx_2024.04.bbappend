FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2024.04_6.6.23_2.0.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "3c507779839d8283406b8fcd95c9d456e46e4497"

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
