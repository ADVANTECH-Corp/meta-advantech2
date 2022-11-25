
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://ModemManager.service"

do_install_append() {
	install -d ${D}/lib/systemd/system
	install -m 644 ${WORKDIR}/ModemManager.service ${D}/lib/systemd/system/ModemManager.service
}

SYSTEMD_AUTO_ENABLE_${PN} = "disable"
