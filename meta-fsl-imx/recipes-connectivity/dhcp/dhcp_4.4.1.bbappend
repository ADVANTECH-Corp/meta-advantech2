SUMMARY = "ADV dhcp service"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://dhcpd.service \
		file://dhcpd.conf \
		file://dhcp-server"

inherit systemd

do_install_append() {
        install -d ${D}/lib/systemd/system
        install -d ${D}/etc/dhcp
        install -d ${D}/etc/default
	install -m 644 ${WORKDIR}/dhcpd.service ${D}/lib/systemd/system/dhcpd.service
	install -m 644 ${WORKDIR}/dhcpd.conf ${D}/etc/dhcp/dhcpd.conf
	install -m 644 ${WORKDIR}/dhcp-server ${D}/etc/default/dhcp-server
}

SYSTEMD_AUTO_ENABLE_${PN}-server = "enable"

