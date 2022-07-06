SUMMARY = "ADV SW Router"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv-router.service \
	   file://adv-router \
	   file://10-eth0-static.network"

inherit systemd

do_install() {
	install -d ${D}/usr/sbin
	install -d ${D}/etc/systemd/network
	install -m 755 ${WORKDIR}/adv-router ${D}/usr/sbin/adv-router
	install -m 644 ${WORKDIR}/10-eth0-static.network ${D}/etc/systemd/network/10-eth0-static.network

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-router.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "adv-router.service"

