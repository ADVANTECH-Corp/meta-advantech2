SUMMARY = "emmc lifetime for risc platform"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/ADVANTECH-Corp/RISC_tools_source;module=ecsd_1.0;protocol=https"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/ecsd_1.0"

inherit autotools pkgconfig
RDEPENDS_${PN} += "bash"

EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

do_install() {
    install -d ${D}/tools
    install -m 755 ${S}/emmc_lifetime.sh ${D}/tools/

    install -d ${D}/usr/sbin
    install -m 755 ${B}/ecsd ${D}/usr/sbin/
}

FILES_${PN} = "/tools /usr/sbin"

COMPATIBLE_MACHINE = "(mx8)"
