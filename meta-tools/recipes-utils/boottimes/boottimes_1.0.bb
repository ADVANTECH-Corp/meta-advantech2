SUMMARY = "Advantech boottimes tool"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "https://github.com/ADVANTECH-Corp/RISC_tools_source/raw/master/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "1846b19db3dfa31ff5ce13d6472d4b9d"
SRC_URI[sha256sum] = "18572d013a1c4ac24a633ecfd5b003490a1237944cb81b15eb80c7f831de8264"

S = "${WORKDIR}/boot_times"

inherit autotools pkgconfig

EXTRA_OECONF = "--host arm-poky-linux-gnueabi"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}
