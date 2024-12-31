DESCRIPTION = "Open PLC Utilities"
SECTION = "base"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "git://github.com/qca/open-plc-utils.git;protocol=https;branch=master"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

do_configure[noexec] = "1"

do_compile() {
	export LDFLAGS="${BUILD_LDFLAGS}"
	oe_runmake -C ${S} CROSS='${TARGET_SYS}-' EXTRA_CFLAGS="-I${STAGING_INCDIR}" EXTRA_CXXFLAGS="-I${STAGING_INCDIR}" EXTRA_LDFLAGS="--sysroot=${STAGING_DIR_TARGET}"
}

do_install() {
	install -d ${WORKDIR}/build
	make ROOTFS="${WORKDIR}/build" install

	install -d ${D}/usr/bin
	install -m 755 ${WORKDIR}/build/usr/local/bin/* ${D}/usr/bin/
}

INSANE_SKIP:${PN} = "ldflags"

COMPATIBLE_MACHINE = "(mx93-nxp-bsp)"
