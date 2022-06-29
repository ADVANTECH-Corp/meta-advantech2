SUMMARY = "Power on/off service"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://power-test.sh \
	   file://adv-power-test.service"

inherit systemd
RDEPENDS_${PN} += "bash"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/power-test.sh ${D}/tools/power-test.sh

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv-power-test.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "adv-power-test.service"

FILES_${PN} = "/tools"
