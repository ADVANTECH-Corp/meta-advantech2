SUMMARY = "Configure kernel modules to load at booti"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://advantech.conf \
"

do_install () {
	install -d ${D}${sysconfdir}/modules-load.d
        install -m 0755    ${WORKDIR}/advantech.conf       ${D}${sysconfdir}/modules-load.d	
}

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
