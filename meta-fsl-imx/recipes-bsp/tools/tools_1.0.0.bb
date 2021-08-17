SUMMARY = "Factory test programs for IMX BSP"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://usb_mount.patch"

S = "${WORKDIR}/tools"

inherit autotools pkgconfig

do_install() {
	mkdir -p ${D}/tools
	install -m 0775 ${S}/usb_mount ${D}/tools
}

# List the files for Package
FILES_${PN} += "/tools"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
