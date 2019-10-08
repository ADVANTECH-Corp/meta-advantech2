SUMMARY = "A stress shell script that Linaro provides for basic test"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://stress.sh \
	   file://log.sh \
	   file://gpu.sh \
	   file://power-test \
	   file://power-test.service"

inherit systemd

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/stress.sh ${D}/tools/stress.sh
    install -m 755 ${WORKDIR}/log.sh ${D}/tools/log.sh
    install -m 755 ${WORKDIR}/gpu.sh ${D}/tools/gpu.sh

    # SysV
    if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','true','false',d)}; then
        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/power-test ${D}${sysconfdir}/init.d/power-test
    fi

    # Systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/power-test.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "power-test.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILES_${PN} = "/tools ${sysconfdir}/init.d"
