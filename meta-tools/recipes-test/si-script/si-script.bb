SUMMARY = "The shell scripts for SI test"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://modelist.sh \
	   file://si_display.sh \
	   file://si_eth_100M.sh \
	   file://si_eth_1G.sh \
	   file://si_usb2_host.sh \
	   file://si_usb2_otg_host.sh \
	   file://si_usb3_host.sh"

do_install() {
    install -d ${D}/tools/si
    install -m 755 ${WORKDIR}/*.sh ${D}/tools/si/
}

FILES_${PN} = "/tools/si"

COMPATIBLE_MACHINE = "(mx8)"
