FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_6.12.20_2.0.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "32108bcbc1ca89adaa26d963bc38ee159cee0502"
SCMVERSION = "n"

# Linux Kernel Localversion
LOCALVERSION = ""

do_copy_defconfig:mx9-nxp-bsp () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
}

do_kernel_localversion_force() {

    # Force overwrite kernel localversion
    sed -i -e "/CONFIG_LOCALVERSION[ =]/d" ${B}/.config
    echo "CONFIG_LOCALVERSION=\"${LOCALVERSION}\"" >> ${B}/.config
    sed -i -e "/CONFIG_LOCALVERSION_AUTO[ =]/d" ${B}/.config
    echo "CONFIG_LOCALVERSION_AUTO=y" >> ${B}/.config
}

addtask kernel_localversion_force before do_configure after do_kernel_localversion
