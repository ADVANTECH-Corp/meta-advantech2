SUMMARY = "Advantech rtd_converter for i.MX platform"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/ADVANTECH-Corp/RISC_tools_source;module=rtd_converter;branch=master;protocol=https"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/rtd_converter"

inherit autotools pkgconfig

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
    install -m 755 ${D}/usr/bin/rtd_converter ${SYSROOT_DESTDIR}/usr/bin/
}

