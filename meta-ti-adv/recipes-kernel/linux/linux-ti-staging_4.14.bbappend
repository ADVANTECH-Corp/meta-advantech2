
KERNEL_GIT_URI = "https://github.com/ADVANTECH-Corp/linux-ti.git"
BRANCH = "linux-ti-staging-05.03.00"
SRCREV = "${AUTOREV}"

RDEPENDS_kernel-base_append_am335xrom3310a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xrsb4220a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xrsb4221a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xepcr3220a1 = " prueth-fw"

do_configure_append() {
    # Always copy the defconfig file to .config to keep consistency
    # between the case where there is a real config and the in kernel
    # tree config

    if [ "${SOC_FAMILY}" = "ti-soc:omap-a15:dra7xx" ] ; then
        cp ${S}/arch/arm/configs/am57xx-adv_defconfig ${B}/.config
    elif [ "${SOC_FAMILY}" = "ti-soc:ti33x" ] ; then
        cp ${S}/arch/arm/configs/am335x-adv_defconfig ${B}/.config
    fi

    cp ${B}/.config ${S}/arch/${ARCH}/configs/${CONFIG_NAME}

}

