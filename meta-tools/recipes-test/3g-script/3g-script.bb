SUMMARY = "A shell script for 3G data connection"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://telit3g.sh \
	   file://ewm-c106.sh \
	   file://sierra-em7565.sh \
	   file://3glink \
	   file://3g.chat"

do_install() {
    # Telit
    install -d ${D}/tools
    install -d ${D}/tools/ppp
    install -m 755 ${WORKDIR}/telit3g.sh ${D}/tools/ppp/

    # EWM-C106
    install -m 755 ${WORKDIR}/ewm-c106.sh ${D}/tools/ppp/
    install -d ${D}/etc/ppp/peers
    install -m 644 ${WORKDIR}/3glink ${D}/etc/ppp/peers/
    install -d ${D}/etc/chatscripts
    install -m 644 ${WORKDIR}/3g.chat ${D}/etc/chatscripts/

    # Sierra EM7565
    install -m 755 ${WORKDIR}/sierra-em7565.sh ${D}/tools/ppp/
}

FILES:${PN} = "/tools/ppp"
FILES:${PN} += "/etc/ppp/peers"
FILES:${PN} += "/etc/chatscripts"
