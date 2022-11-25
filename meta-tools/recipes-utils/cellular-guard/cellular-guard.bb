SUMMARY = "Cellular guard service"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://cellular-guard.service \
	   file://cellular-guard.sh \
           file://gpio"

inherit systemd

do_install() {
    install -d ${D}/tools
    install -d ${D}/usr/sbin
    install -m 755 ${WORKDIR}/cellular-guard.sh ${D}/tools/cellular-guard.sh
    install -m 755 ${WORKDIR}/gpio ${D}/usr/sbin/gpio

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/cellular-guard.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "cellular-guard.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILES_${PN} += "/tools /usr/sbin"
