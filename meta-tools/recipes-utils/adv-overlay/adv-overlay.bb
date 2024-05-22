SUMMARY = "ADV Overlay"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"


SRC_URI = "file://ADV_OVERLAY \
			file://ntp.conf \
			file://adv-overlay.sh \
			file://adv-overlay.service "

inherit systemd

do_install() {
	install -d ${D}/tools/adv-overlay
	install -m 0644 ${WORKDIR}/ADV_OVERLAY ${D}/tools/adv-overlay/ADV_OVERLAY
	install -m 0755 ${WORKDIR}/adv-overlay.sh ${D}/tools/adv-overlay/adv-overlay.sh

	install -d ${D}/etc
	install -m 0644 ${WORKDIR}/ntp.conf ${D}/etc/ntp.conf

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-overlay.service ${D}${systemd_unitdir}/system
    fi


}

SYSTEMD_SERVICE:${PN} = "adv-overlay.service"
FILES:${PN} = "/tools /etc "
