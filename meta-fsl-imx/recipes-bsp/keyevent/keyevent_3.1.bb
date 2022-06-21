SUMMARY = "Advantech key_event for i.MX platform"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "git://github.com/ADVANTECH-Corp/RISC_tools_source;module=key_event_3.1;protocol=https"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/key_event_3.1"

inherit autotools pkgconfig

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi CFLAGS=-lpthread"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi CFLAGS=-lpthread"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux CFLAGS=-lpthread"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

# Because /tools is a customized folder, we need to
# install the folder into sysroot by ourselves.
SYSROOT_PREPROCESS_FUNCS += "diag_sysroot_preprocess"

diag_sysroot_preprocess() {
    install -d ${SYSROOT_DESTDIR}/usr
    install -d ${SYSROOT_DESTDIR}/usr/bin
    install -m 755 ${D}/usr/bin/key_event ${SYSROOT_DESTDIR}/usr/bin/
}

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
