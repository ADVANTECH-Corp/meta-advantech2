FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_6.1.1_1.0.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "${AUTOREV}"
SCMVERSION = "n"

# Fix Linux Kernel Localversion
LOCALVERSION = ""

do_copy_defconfig:mx6-nxp-bsp() {
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_defconfig ${B}/../defconfig
}

do_copy_defconfig:mx7-nxp-bsp () {
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/.config
    cp ${S}/arch/arm/configs/imx_v7_adv_imx7_defconfig ${B}/../defconfig
}

do_copy_defconfig:mx8-nxp-bsp () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
}

addtask kernel_localversion_force before do_configure after do_kernel_localversion
