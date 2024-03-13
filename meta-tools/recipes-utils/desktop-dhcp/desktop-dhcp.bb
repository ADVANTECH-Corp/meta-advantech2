SUMMARY = "ADV Desktop DHCP"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

#inherit packagegroup
#PACKAGECONFIG ??= ""
#PACKAGECONFIG:append = " dhcp-server"

SRC_URI = "file://dhcpd.conf \
	   file://isc-dhcp-server "



do_install() {
	install -d ${D}/etc/dhcp
	install -d ${D}/etc/default
#	install -m 644 ${WORKDIR}/dhcpd.conf ${D}/etc/dhcp/dhcpd.conf
	install -m 644 ${WORKDIR}/isc-dhcp-server ${D}/etc/default/isc-dhcp-server

}

FILES:${PN} = "/etc/dhcp /etc/default "
