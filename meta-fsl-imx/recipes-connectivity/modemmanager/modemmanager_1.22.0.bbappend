
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://ModemManager.service"

do_install:append() {
	install -d ${D}${systemd_system_unitdir}
	install -m 644 ${WORKDIR}/ModemManager.service ${D}${systemd_system_unitdir}/ModemManager.service
}

SYSTEMD_SERVICE:${PN} = "ModemManager.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
FILES:${PN} += "${systemd_system_unitdir}/ModemManager.service "
