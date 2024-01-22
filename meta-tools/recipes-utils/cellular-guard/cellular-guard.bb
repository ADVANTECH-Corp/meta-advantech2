SUMMARY = "Cellular guard service"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://cellular-guard.service \
          git://github.com/ADVANTECH-Corp/cellular_guard;protocol=https;branch=main"

SRCREV = "${AUTOREV}"

inherit systemd

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/git/entry.sh ${D}/tools/cellular-guard.sh
    # systemd
    if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
        install -d ${D}${systemd_unitdir}/system
        install -m 0644 ${WORKDIR}/cellular-guard.service ${D}${systemd_unitdir}/system
    fi
}

SYSTEMD_SERVICE:${PN} = "cellular-guard.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"

FILES:${PN} += "/tools"
