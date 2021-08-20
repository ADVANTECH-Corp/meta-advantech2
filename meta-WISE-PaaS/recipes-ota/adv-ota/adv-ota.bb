SUMMARY = "Main program for OTA update in recovery mode"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://adv-ota.sh "
SRC_URI_append_armv7a = "file://adv-reboot-32 "
SRC_URI_append_aarch64 = "file://adv-reboot-64 "

S = "${WORKDIR}"

do_install() {
    mkdir -p ${D}/tools
    install -d ${D}/tools

    install -m 755 ${WORKDIR}/adv-ota.sh ${D}/tools/adv-ota.sh

    if [ -e ${WORKDIR}/adv-reboot-32 ] ; then
        install -m 755 ${WORKDIR}/adv-reboot-32 ${D}/tools/adv-reboot
    fi
    if [ -e ${WORKDIR}/adv-reboot-64 ] ; then
        install -m 755 ${WORKDIR}/adv-reboot-64 ${D}/tools/adv-reboot
    fi
}

RDEPENDS_${PN} += "bash"
FILES_${PN} = "/tools"

