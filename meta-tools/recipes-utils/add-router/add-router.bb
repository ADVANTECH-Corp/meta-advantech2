SUMMARY = "ADV SW Router"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://10-eth0-static.network "


do_install() {
	install -d ${D}/etc/systemd/network
	install -m 644 ${WORKDIR}/10-eth0-static.network ${D}/etc/systemd/network/10-eth0-static.network

}


FILES:${PN} = "/etc"
