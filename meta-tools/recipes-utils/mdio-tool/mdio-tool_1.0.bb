SUMMARY = "Mdio Tool"
SECTION = "base"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "git://github.com/PieVo/mdio-tool.git;protocol=https;branch=master"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig

EXTRA_OECONF = "--host arm-poky-linux-gnueabi"

