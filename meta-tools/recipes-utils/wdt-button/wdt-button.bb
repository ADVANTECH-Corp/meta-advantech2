SUMMARY = "Advantech wdt_button_test for i.MX platform"
SECTION = "base"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/ADVANTECH-Corp/RISC_tools_source;module=wdt_button_test;protocol=https"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git/wdt_button_test"

inherit autotools pkgconfig

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi CFLAGS=-lpthread"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi CFLAGS=-lpthread"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux CFLAGS=-lpthread"

# We overwrite do_configure() to avoid perform autoreconf again
do_configure() {
    oe_runconf
}

do_install() {
    install -d ${D}/tools
    install -m 755 ${B}/src/wdt_button_test ${D}/tools
}

FILES_${PN} = "/tools"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"
