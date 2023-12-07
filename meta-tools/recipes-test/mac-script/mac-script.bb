SUMMARY = "A shell script to update MAC address of LAN"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://update-mac_smsc75xx.sh"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/update-mac_smsc75xx.sh ${D}/tools/update-mac_smsc75xx.sh
}

FILES:${PN} = "/tools"
