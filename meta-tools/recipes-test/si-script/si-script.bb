SUMMARY = "The shell scripts for SI test"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://mx8/modelist.sh \
	   file://mx8/si_display.sh \
	   file://mx8/si_eth_100M.sh \
	   file://mx8/si_eth_1G.sh \
	   file://mx8/si_usb2_host.sh \
	   file://mx8/si_usb2_otg_host.sh \
	   file://mx8/si_usb3_host.sh"

do_install() {
    install -d ${D}/tools/si
    install -m 755 ${WORKDIR}/mx8/*.sh ${D}/tools/si/
}

FILES:${PN} = "/tools/si"

COMPATIBLE_MACHINE = "(mx8)"
