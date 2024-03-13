SUMMARY = "ADV Wifi Modeprobe"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv_wifi_modeprob_nxp.sh \
	file://adv-wifi-modprobe.service "

inherit systemd

do_install() {
	install -d ${D}/tools
	install -m 755 ${WORKDIR}/adv_wifi_modeprob_nxp.sh ${D}/tools/adv_wifi_modeprob_nxp.sh

    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-wifi-modprobe.service ${D}${systemd_unitdir}/system
    fi

}

SYSTEMD_SERVICE:${PN} = "adv-wifi-modprobe.service"
FILES:${PN} = " /tools "
