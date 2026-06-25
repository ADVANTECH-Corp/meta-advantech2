FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KERNEL_BRANCH = "adv_6.6.23_2.0.0"
KERNEL_SRC = "git://github.com/ADVANTECH-Corp/linux-imx.git;protocol=https"
SRC_URI = "${KERNEL_SRC};branch=${KERNEL_BRANCH}"
SRCREV = "${AUTOREV}"
SCMVERSION = "n"

# Linux Kernel Localversion
LOCALVERSION = ""
GITHASH_SUFFIX = "n"

do_copy_defconfig:mx6-nxp-bsp () {
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

do_copy_defconfig:mx9-nxp-bsp () {
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
}

do_configure:append() {
    NEW_LOCALVERSION="${LOCALVERSION}"

    if [ "${GITHASH_SUFFIX}" = "y" ]; then
        HASH=$(cd ${S} && git rev-parse --short=12 HEAD)
        if [ -n "${HASH}" ] && [ "${HASH}" != "unknown" ]; then
            NEW_LOCALVERSION="${NEW_LOCALVERSION}-g${HASH}"
            bbnote "Final HASH=${HASH}"
        else
            bbwarn "HASH is empty or invalid, skipping suffix"
        fi
        bbnote "Final LOCALVERSION=${NEW_LOCALVERSION}"
    fi

    oe_runmake olddefconfig
    ${S}/scripts/config --file ${B}/.config --disable LOCALVERSION_AUTO
    ${S}/scripts/config --file ${B}/.config --set-str LOCALVERSION "${NEW_LOCALVERSION}"
}

