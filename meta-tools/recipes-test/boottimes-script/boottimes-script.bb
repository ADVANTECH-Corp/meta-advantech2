SUMMARY = "Boot times counter service"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://boottimes.sh \
	   file://boottimes.service"

inherit systemd
RDEPENDS_${PN} += "bash"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/boottimes.sh ${D}/tools/boottimes.sh

    #sysvinit
    if ${@bb.utils.contains('DISTRO_FEATURES','sysvinit','true','false',d)}; then
        install -d ${D}${sysconfdir}/init.d
        install -m 0755 ${WORKDIR}/power-test ${D}${sysconfdir}/init.d/power-test
    fi

    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/boottimes.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE_${PN} = "boottimes.service"

FILES_${PN} = "/tools ${sysconfdir}/init.d"
