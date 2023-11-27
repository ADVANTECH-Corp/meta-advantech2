SUMMARY = "ADV SW DHCP"
LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://adv_dhcp.o \
	   file://adv_dhcp_conf.service "

inherit systemd

do_install() {
	install -d ${D}/tools
	install -m 755 ${WORKDIR}/adv_dhcp.o ${D}/tools

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/adv_dhcp_conf.service ${D}${systemd_unitdir}/system
    fi
}


SYSTEMD_SERVICE_${PN} = "adv_dhcp_conf.service"

FILES_${PN} = "/tools "
