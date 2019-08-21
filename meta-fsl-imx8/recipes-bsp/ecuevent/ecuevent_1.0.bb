SUMMARY = "Advantech key_event for i.MX platform"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "https://github.com/ADVANTECH-Corp/RISC_tools_source/raw/master/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "1fe7fe99f057350af6ea6f2c2fab0d35"
SRC_URI[sha256sum] = "2feee6af72850712da0adbf4f7ab4667e1dc1e17a28bbaa2d3bcfb795a2643b9"


S = "${WORKDIR}/ec_uevent"

inherit autotools pkgconfig

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

SYSROOT_PREPROCESS_FUNCS += "ec_sysroot_preprocess"

ec_sysroot_preprocess() {
    install -d ${SYSROOT_DESTDIR}/usr
    install -d ${SYSROOT_DESTDIR}/usr/bin
    install -m 755 ${D}/usr/bin/ec_uevent ${SYSROOT_DESTDIR}/usr/bin/
}

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
