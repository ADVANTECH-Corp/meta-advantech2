SUMMARY = "A weston exception handle script"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://weston_boot_exception.sh"

do_install() {
	install -d ${D}/tools
	install -m 755 ${WORKDIR}/weston_boot_exception.sh ${D}/tools/weston_boot_exception.sh
}

FILES:${PN} = "/tools"
