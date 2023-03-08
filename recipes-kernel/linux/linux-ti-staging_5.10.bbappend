
RDEPENDS_${KERNEL_PACKAGE_NAME}-base_append_am62xx-rs10 = " tifs-lpm-stub"

KERNEL_GIT_URI = "git://github.com/ADVANTECH-Corp/linux-ti.git"
BRANCH = "linux-am623x-staging-08.06.00.42"
SRCREV = "${AUTOREV}"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_am62xx = " \
    file://0001-Advantech-added-rs10-ti-kernel.patch \
"
