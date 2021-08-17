SUMMARY = "Advantech rs-485 test tool for i.MX platform"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "https://github.com/ADVANTECH-Corp/RISC_tools_source/raw/master/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "16674247c9543d34d5991e3e8fcdcdc3"
SRC_URI[sha256sum] = "8436635ba0991310d9555acbd8ad2bfeca2dde12cbe6faf1c4c9869a8260f758"


S = "${WORKDIR}/st"

inherit autotools pkgconfig

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi --prefix=/usr/"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi --prefix=/usr/"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux --prefix=/usr/"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
