# Copyright (C) 2019 Advantech

DESCRIPTION = "Advantech SUSI4.0"
LICENSE = "Proprietary"
SECTION = "libs"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
PR = "r0"

SRC_URI_mx6 = "file://IMX6_SUSI4__Release_2019_05_27_ubuntu12.04.1_x64_fsl_yocto.tar.gz"
SRC_URI_mx6[md5sum] = "51e2a24c6ecb8064143a8dd84a10a1bf"
SRC_NAME_mx6 = "SUSI4.0.15477"

SRC_URI_dragonboard-410c = "file://Susi4_qualcomm_dragon_yocto_Release__2017-05-11.tar.gz"
SRC_URI_dragonboard-410c[md5sum] = "a45b53f822ce18b77411ed66bd607a43"
SRC_NAME_dragonboard-410c = "SUSI4.0.14490"

SRC_URI_arago = "file://TI_SUSI4_Release_2018_03_02_ubuntu14.04_x64_ti_yocto.tar.gz"
SRC_URI_arago[md5sum] = "ff30559a39f7e8cf25857b444df41ee6"
SRC_NAME_arago = "SUSI4.0.14533"

S = "${WORKDIR}/${SRC_NAME}"

INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

DEPENDS = "zlib pciutils"

do_install() {
	install -d ${D}/usr/lib/Advantech/Susi/ini
	cp -axr ${S}/Driver/ini/*.ini ${D}/usr/lib/Advantech/Susi/ini
	cp -axr ${S}/Driver/lib*.* ${D}/usr/lib/

	install -d ${D}/usr/bin
	cp -axr ${S}/Susi4Demo/susidemo4 ${D}/usr/bin/
}

# List the files for Package
FILES_${PN} += "/usr"

# Put all SO files in main rpm package
FILES_SOLIBSDEV = ""
INSANE_SKIP_${PN} += "dev-so"

# Set alias of susi4 to libsusi-4.00 which is identical to the package name
RPROVIDES_${PN} = "libsusi-4.00"
