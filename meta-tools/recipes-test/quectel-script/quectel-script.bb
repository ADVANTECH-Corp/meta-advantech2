SUMMARY = "A shell script for Quectel LTE data connection"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://quectel-chat-connect \
           file://quectel-chat-disconnect \
           file://quectel-ppp \
           file://quectel-ppp-kill \
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

FILES_${PN} = "/tools/ppp"
FILES_${PN} += "/etc/ppp/peers"
