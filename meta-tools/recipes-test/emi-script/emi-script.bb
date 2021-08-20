SUMMARY = "Shell scripts for EMI test"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://emi_run \
	   file://emi_rs232.sh \
	   file://dupchar.sh \
	   file://emi-test.service"

inherit systemd

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/emi_run ${D}/tools/emi_run
    install -m 755 ${WORKDIR}/emi_rs232.sh ${D}/tools/emi_rs232.sh
    install -m 755 ${WORKDIR}/dupchar.sh ${D}/tools/dupchar.sh

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/emi-test.service ${D}${systemd_unitdir}/system
}

SYSTEMD_SERVICE_${PN} = "emi-test.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILES_${PN} = "/tools"
