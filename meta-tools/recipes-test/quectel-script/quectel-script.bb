SUMMARY = "A shell script for Quectel LTE data connection"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

INSANE_SKIP:${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

SRC_URI = "file://quectel-chat-connect \
           file://quectel-chat-disconnect \
           file://quectel-ppp \
           file://quectel-ppp-kill \
           file://quectel-CM \
           file://ec-25-a.sh \
           file://quectel-pppd.sh"

do_install() {
    install -d ${D}/tools
    install -d ${D}/tools/ppp
    install -m 755 ${WORKDIR}/ec-25-a.sh ${D}/tools/ppp/
    install -m 755 ${WORKDIR}/quectel-pppd.sh ${D}/tools/ppp/
    install -m 755 ${WORKDIR}/quectel-ppp-kill ${D}/tools/ppp/

    install -d ${D}/etc/ppp/peers
    install -m 644 ${WORKDIR}/quectel-chat-connect ${D}/etc/ppp/peers/
    install -m 644 ${WORKDIR}/quectel-chat-disconnect ${D}/etc/ppp/peers/
    install -m 644 ${WORKDIR}/quectel-ppp ${D}/etc/ppp/peers/
}

FILES:${PN} = "/tools/ppp"
FILES:${PN} += "/etc/ppp/peers"
