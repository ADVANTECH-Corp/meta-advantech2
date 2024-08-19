SUMMARY = "ADV DNS_add 114 and 8 , add wieless file for HDCP"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://resolv.conf file://10-wireless.network"


do_install() {
    install -d ${D}/etc
    install -m 755 ${WORKDIR}/resolv.conf ${D}/etc/resolv.conf
	install -d ${D}/etc/systemd/network
	install -m 0644 ${WORKDIR}/10-wireless.network ${D}/etc/systemd/network/10-wireless.network

}


FILES:${PN} = "/etc"
