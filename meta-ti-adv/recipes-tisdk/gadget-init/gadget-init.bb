DESCRIPTION = "Units to initialize usb gadgets"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690"

PR = "r0"

COMPATIBLE_MACHINE = "ti33x"

RDEPENDS_${PN} += "busybox-udhcpd"

SRC_URI = "file://storage-gadget-init.service \
           file://storage-gadget-init.sh \
"

inherit systemd

SYSTEMD_SERVICE_${PN} = "storage-gadget-init.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/storage-gadget-init.sh ${D}${bindir}

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/storage-gadget-init.service ${D}${systemd_system_unitdir}
}

RRECOMMENDS_${PN} += "kernel-module-g_mass_storage"
