SUMMARY = "Power on/off service"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://power-test.sh \
	   file://adv-power-test.service"

inherit systemd
RDEPENDS:${PN} += "bash"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/power-test.sh ${D}/tools/power-test.sh

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-power-test.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE:${PN} = "adv-power-test.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN} = "/tools"
