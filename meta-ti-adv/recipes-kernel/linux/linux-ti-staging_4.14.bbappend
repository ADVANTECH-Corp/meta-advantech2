
KERNEL_GIT_URI = "git://github.com/ADVANTECH-Corp/linux-ti.git"
BRANCH = "linux-ti-staging-05.03.00"
SRCREV = "93d305b66f177533606c9d5b8acb0afa39abf895"

RDEPENDS_kernel-base_append_am335xrom3310a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xrsb4220a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xrsb4221a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am335xepcr3220a1 = " prueth-fw"
RDEPENDS_kernel-base_append_am57xxrom7510a1 = " pruhsr-fw pruprp-fw prueth-fw"
RDEPENDS_kernel-base_append_am57xxrom7510a2 = " pruhsr-fw pruprp-fw prueth-fw"

CMEM_MACHINE_am57xxrom7510a1 = "am571x am572x am574x"
CMEM_MACHINE_am57xxrom7510a2 = "am571x am572x am574x"

do_configure_append() {
    # Always copy the defconfig file to .config to keep consistency
    # between the case where there is a real config and the in kernel
    # tree config

    if [ "${SOC_FAMILY}" = "ti-soc:omap-a15:dra7xx" ] ; then
        cp ${S}/arch/arm/configs/am57xx-adv_defconfig ${B}/.config
        cp ${S}/arch/arm/configs/am57xx-adv_defconfig ${WORKDIR}/defconfig
    elif [ "${SOC_FAMILY}" = "ti-soc:ti33x" ] ; then
        cp ${S}/arch/arm/configs/am335x-adv_defconfig ${B}/.config
    fi

    cp ${B}/.config ${S}/arch/${ARCH}/configs/${CONFIG_NAME}

}

