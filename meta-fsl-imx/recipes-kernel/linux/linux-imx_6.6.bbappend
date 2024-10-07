FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_6.6.36_2.1.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "${AUTOREV}"
SCMVERSION = "n"

do_copy_defconfig:mx9-nxp-bsp () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
}
