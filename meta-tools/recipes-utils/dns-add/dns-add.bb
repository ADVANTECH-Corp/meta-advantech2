SUMMARY = "ADV DNS_add 114 and 8"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://resolv.conf "


do_install() {
    install -d ${D}/etc
    install -m 755 ${WORKDIR}/resolv.conf ${D}/etc/resolv.conf

}


FILES:${PN} = "/etc"
