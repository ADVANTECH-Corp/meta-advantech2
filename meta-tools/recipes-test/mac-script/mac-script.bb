SUMMARY = "A shell script to update MAC address of LAN"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://update-mac_smsc75xx.sh"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/update-mac_smsc75xx.sh ${D}/tools/update-mac_smsc75xx.sh
}

FILES_${PN} = "/tools"
