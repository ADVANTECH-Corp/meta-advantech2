SUMMARY = "ADV ISC Kea DHCP Server"
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += "file://kea-dhcp4.conf "

#inherit systemd

do_install:append() {
        install -d ${D}/etc/default
        install -m 644 ${WORKDIR}/kea-dhcp4.conf ${D}/etc/kea/kea-dhcp4.conf
}

SYSTEMD_AUTO_ENABLE:${PN} = "enable"

