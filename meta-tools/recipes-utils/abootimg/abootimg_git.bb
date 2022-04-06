SUMMARY = "A tool to read/write/update android boot images"
HOMEPAGE = "https://gitorious.org/ac100/abootimg"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

DEPENDS = "util-linux"

PV = "0.6+gitr${SRCPV}"

SRC_URI = "git://gitorious.org/ac100/abootimg.git;protocol=https;branch=master"
SRCREV = "7e127fee6a3981f6b0a50ce9910267cd501e09d4"
S = "${WORKDIR}/git"

EXTRA_OEMAKE = "-e MAKEFLAGS="

BBCLASSEXTEND = "native"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/abootimg ${D}${bindir}
    install -m 0755 ${S}/abootimg-pack-initrd ${D}${bindir}
    install -m 0755 ${S}/abootimg-unpack-initrd ${D}${bindir}
}
