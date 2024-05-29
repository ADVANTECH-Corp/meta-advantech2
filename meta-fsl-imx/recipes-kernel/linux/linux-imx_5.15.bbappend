FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_5.15.52_2.1.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "4ae5a29829355087afe74862d8f3f0964a214b17"
SCMVERSION = "n"


do_copy_defconfig:mx6-nxp-bsp () {
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/../defconfig
}

do_copy_defconfig:mx7-nxp-bsp () {
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/../defconfig
}

do_copy_defconfig:mx8-nxp-bsp () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_r5710_ubuntu22_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_r5710_ubuntu22_defconfig ${B}/../defconfig
}
