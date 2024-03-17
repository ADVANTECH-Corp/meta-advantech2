SUMMARY = "ADV Overlay"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"


SRC_URI = "file://dhcpd.conf \
			file://ADV_OVERLAY \
			file://adv-overlay.sh \
			file://adv-overlay.service "

inherit systemd

do_install() {
	install -d ${D}/tools
	install -m 0644 ${WORKDIR}/dhcpd.conf ${D}/tools/dhcpd.conf
	install -m 0644 ${WORKDIR}/ADV_OVERLAY ${D}/tools/ADV_OVERLAY
	install -m 0644 ${WORKDIR}/adv-overlay.sh ${D}/tools/adv-overlay.sh

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-overlay.service ${D}${systemd_unitdir}/system
    fi


}

SYSTEMD_SERVICE:${PN} = "adv-overlay.service"
FILES:${PN} = "/tools "
