SUMMARY = "Factory test programs for IMX BSP"
SECTION = "base"
LICENSE = "GPLv2"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

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
