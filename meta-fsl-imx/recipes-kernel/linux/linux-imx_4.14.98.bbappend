FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "imx_4.14.98_2.0.0_ga"
LOCALVERSION = "-${SRCBRANCH}"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx6.git;protocol=https;branch=${SRCBRANCH}"
SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"
SRCREV = "412aee9b6a448c8c4c58644733cd39df1fc89cd5"
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
    cp ${S}/arch/arm64/configs/imx8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx8_adv_defconfig ${B}/../defconfig
}

