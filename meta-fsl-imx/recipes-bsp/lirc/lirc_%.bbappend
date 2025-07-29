FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

do_install:append() {
	install -m 0644 ${UNPACKDIR}/lircd.conf ${D}${sysconfdir}/lirc/
	install -m 0644 ${UNPACKDIR}/lircd.service ${D}${systemd_unitdir}/system/
}
