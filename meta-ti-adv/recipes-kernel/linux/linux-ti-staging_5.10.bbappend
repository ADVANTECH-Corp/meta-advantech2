
RDEPENDS_${KERNEL_PACKAGE_NAME}-base_append_am62xx-rs10 = " tifs-lpm-stub"

KERNEL_GIT_URI = "git://github.com/ADVANTECH-Corp/linux-ti.git"
BRANCH = "linux-am623x-staging-08.06.00.42"
SRCREV = "${AUTOREV}"

do_configure_append() {
    # Always copy the defconfig file to .config to keep consistency
    # between the case where there is a real config and the in kernel
    # tree config

    cp ${S}/arch/arm64/configs/tisdk_am62xx-rs10_qmi_defconfig ${B}/.config
    cp ${S}/arch/arm64/configs/tisdk_am62xx-rs10_qmi_defconfig ${WORKDIR}/defconfig
    cp ${B}/.config ${S}/arch/${ARCH}/configs/${CONFIG_NAME}
}
