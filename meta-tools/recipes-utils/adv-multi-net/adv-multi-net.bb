SUMMARY = "ADV Multiple Networks"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv_close_service.service \
	   file://adv_close_service.sh "

inherit systemd

do_install() {
	install -d ${D}/tools/adv-muti-networks
	install -m 755 ${WORKDIR}/adv_close_service.sh ${D}/tools/adv-muti-networks/adv_close_service.sh

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
	install -d ${D}${systemd_unitdir}/system
	install -m 0644 ${WORKDIR}/adv_close_service.service ${D}${systemd_unitdir}/system
    fi
}


SYSTEMD_SERVICE:${PN} = "adv_close_service.service"

FILES:${PN} = "/tools "
