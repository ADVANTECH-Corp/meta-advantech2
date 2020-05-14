SUMMARY = "A stress shell script that Linaro provides for basic test"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://stress.sh \
	   file://log.sh \
	   file://gpu.sh \
	   file://eth0.sh \
	   file://eth1.sh \
	   file://play.sh \
	   file://sd.sh \
	   file://uart.sh \
	   file://usb.sh \
	   file://wifi.sh \
	   file://cpu-gpu-vpu.sh \
	   file://stress-test \
	   file://stress-test.service"

inherit systemd

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/stress.sh ${D}/tools/stress.sh
    install -m 755 ${WORKDIR}/log.sh ${D}/tools/log.sh
    install -m 755 ${WORKDIR}/gpu.sh ${D}/tools/gpu.sh
	install -m 755 ${WORKDIR}/eth0.sh ${D}/tools/eth0.sh
	install -m 755 ${WORKDIR}/eth1.sh ${D}/tools/eth1.sh
	install -m 755 ${WORKDIR}/play.sh ${D}/tools/play.sh
	install -m 755 ${WORKDIR}/sd.sh ${D}/tools/sd.sh
	install -m 755 ${WORKDIR}/uart.sh ${D}/tools/uart.sh
	install -m 755 ${WORKDIR}/usb.sh ${D}/tools/usb.sh
	install -m 755 ${WORKDIR}/wifi.sh ${D}/tools/wifi.sh
	install -m 755 ${WORKDIR}/cpu-gpu-vpu.sh ${D}/tools/cpu-gpu-vpu.sh

    # SysV
    if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','true','false',d)}; then
        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/stress-test ${D}${sysconfdir}/init.d/stress-test
    fi

    # Systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/stress-test.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "stress-test.service"
SYSTEMD_AUTO_ENABLE_${PN} = "disable"

FILES_${PN} = "/tools ${sysconfdir}/init.d"
