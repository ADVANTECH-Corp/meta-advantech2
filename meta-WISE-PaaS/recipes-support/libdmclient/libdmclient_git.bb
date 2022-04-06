SUMMARY = "libdmclient implements the client-side of OMA DM 1.2 protocol."
DESCRIPTION = "libdmclient is a communication library for mobile device management. It implements the client-side of OMA DM 1.2 protocol."
HOMEPAGE = "https://01.org/zh/libdmclient"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://dmcore/COPYING;md5=ff253ad767462c46be284da12dda33e8"

PV = "0.0.0+git${SRCPV}"

SRCREV = "9d4e3e8f252ea6e70f9b0b5f8e1fc733852d8c17"
SRC_URI = "git://github.com/01org/libdmclient.git;protocol=https"

inherit autotools-brokensep

S = "${WORKDIR}/git"

DEPENDS = "pkgconfig"
#RDEPENDS_${PN} += "unzip"

BBCLASSEXTEND = "native"
