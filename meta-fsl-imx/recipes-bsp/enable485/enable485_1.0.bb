SUMMARY = "Advantech enable RS-485 tool for i.MX platform"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "https://github.com/ADVANTECH-Corp/RISC_tools_source/raw/master/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "a3b3dab1cb4dad9e0d9ed80661883e43"
SRC_URI[sha256sum] = "9830b43272e5fa71e6200d54342bb5b545b52ab0b5863fa000c8aebfe65423cb"


S = "${WORKDIR}/enable485"

inherit autotools pkgconfig

EXTRA_OECONF:append_mx6 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF:append_mx7 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF:append_mx8 = "--host aarch64-poky-linux"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

SYSROOT_PREPROCESS_FUNCS += "enable485_sysroot_preprocess"

enable485_sysroot_preprocess() {
    install -d ${SYSROOT_DESTDIR}/usr
    install -d ${SYSROOT_DESTDIR}/usr/bin
    install -m 755 ${D}/usr/bin/enable485 ${SYSROOT_DESTDIR}/usr/bin/
}

COMPATIBLE_MACHINE = "(mx6-nxp-bsp|mx7-nxp-bsp|mx8-nxp-bsp|mx9-nxp-bsp)"
