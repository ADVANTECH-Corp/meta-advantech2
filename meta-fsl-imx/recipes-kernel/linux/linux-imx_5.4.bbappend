FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_5.4.70_2.3.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "8b7dd7372131e2a2e6676fce1f4d3d36c1455972"
SCMVERSION = "n"

do_copy_defconfig_mx6 () {
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/../defconfig
}

do_copy_defconfig_mx7 () {
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/../defconfig
}

do_copy_defconfig_mx8 () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
}

