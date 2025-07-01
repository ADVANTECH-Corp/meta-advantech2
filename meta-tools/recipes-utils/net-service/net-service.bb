SUMMARY = "ADV SW Router"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv_network_service.service \
	   file://adv_network_service.sh "

inherit systemd

do_install() {
	install -d ${D}/tools/adv-net-service
	install -m 755 ${WORKDIR}/adv_network_service.sh ${D}/tools/adv-net-service/adv_network_service.sh
    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/adv_network_service.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE:${PN} = "adv_network_service.service"

FILES:${PN} = "/tools "
