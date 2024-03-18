SUMMARY = "ADV SW Router"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://10-eth0-static.network \
		file://adv-router.service \
		file://adv-router "

inherit systemd

do_install() {
	install -d ${D}/tools
	install -d ${D}/etc/systemd/network
	install -m 0644 ${WORKDIR}/10-eth0-static.network ${D}/etc/systemd/network/10-eth0-static.network
	install -m 0755 ${WORKDIR}/adv-router ${D}/tools/adv-router

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-router.service ${D}${systemd_unitdir}/system
    fi

}

SYSTEMD_SERVICE:${PN} = "adv-router.service"
FILES:${PN} = "/etc /tools"
