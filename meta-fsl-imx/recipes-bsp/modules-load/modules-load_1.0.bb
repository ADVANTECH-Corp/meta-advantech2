SUMMARY = "Configure kernel modules to load at booti"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://advantech.conf \
"

do_install () {
	install -d ${D}${sysconfdir}/modules-load.d
        install -m 0755    ${WORKDIR}/advantech.conf       ${D}${sysconfdir}/modules-load.d	
}

COMPATIBLE_MACHINE = "(mx6-nxp-bsp|mx7-nxp-bsp|mx8-nxp-bsp|mx9-nxp-bsp)"
