FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

do_install_append() {
	install -m 0644 ${WORKDIR}/lircd.conf ${D}${sysconfdir}/lirc/
	install -m 0644 ${WORKDIR}/lircd.service ${D}${systemd_unitdir}/system/
}
