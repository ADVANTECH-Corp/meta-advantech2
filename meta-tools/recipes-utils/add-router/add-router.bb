SUMMARY = "ADV SW Router"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv-router.service \
	   file://adv-router \
	   file://10-eth0-static.network \
	   file://adv-wwan0.sh \
	   file://close_resolved_service.sh \
	   file://resolv.conf \
	   file://close_systemd_resolved.service \
	   file://adv-route-wwan0.service "

inherit systemd

do_install() {
	install -d ${D}/usr/sbin
	install -d ${D}/etc/systemd/network
	install -d ${D}/tools
	install -m 755 ${WORKDIR}/adv-router ${D}/usr/sbin/adv-router
	install -m 644 ${WORKDIR}/10-eth0-static.network ${D}/etc/systemd/network/10-eth0-static.network
	install -m 755 ${WORKDIR}/adv-wwan0.sh ${D}/tools
	install -m 755 ${WORKDIR}/close_resolved_service.sh ${D}/tools
	install -m 755 ${WORKDIR}/resolv.conf ${D}/etc/

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-router.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/close_systemd_resolved.service ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/adv-route-wwan0.service ${D}${systemd_unitdir}/system
    fi
}


SYSTEMD_SERVICE:${PN} = "adv-router.service"
SYSTEMD_SERVICE:${PN} += "close_systemd_resolved.service"
SYSTEMD_SERVICE:${PN} += "adv-route-wwan0.service"

FILES:${PN} = "/tools /usr/sbin /etc"
