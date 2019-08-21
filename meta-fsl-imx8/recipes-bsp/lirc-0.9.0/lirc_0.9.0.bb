SUMMARY = "LIRC is an IR remote controls"
DESCRIPTION = "LIRC is a package that allows you to decode and send infra-red signals of many (but not all) commonly used remote controls."
HOMEPAGE = "http://www.lirc.org/"
SECTION = "base"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=0636e73ff0215e8d672dc4c32c317bb3"

SRC_URI = "http://ncu.dl.sourceforge.net/project/lirc/LIRC/${PV}/${BPN}-${PV}.tar.gz \
           file://lircd_conf.patch \
           file://lircrc.patch \
           file://configure.patch"

SRC_URI[md5sum] = "83e97622acc4aa38a2f0cb102f4c00ef"
SRC_URI[sha256sum] = "863b5c6e2a43f2699d3198827985ee87788a215fff42be6d2408c71d8d562a2e"

inherit autotools pkgconfig

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi --localstatedir=/var --with-driver=userspace --without-x"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi --localstatedir=/var --with-driver=userspace --without-x"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux --localstatedir=/var --with-driver=userspace --without-x"

# List the files for Package
FILES_${PN} += "/run/lirc"

# Build-time dependencies
DEPENDS = "libusb"

COMPATIBLE_MACHINE = "(mx6|mx7|mx8)"

# disable unneeded task at present
do_package_qa[noexec] = "1"

