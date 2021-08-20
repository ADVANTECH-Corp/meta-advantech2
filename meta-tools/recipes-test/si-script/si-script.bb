SUMMARY = "The shell scripts for SI test"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

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
