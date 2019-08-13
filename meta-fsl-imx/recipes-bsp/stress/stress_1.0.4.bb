SUMMARY = "stress is a deliberately simple workload generator for POSIX systems"
DESCRIPTION = "A deliberately simple workload generator which imposes a configurable amount of CPU, memory, I/O, and disk stress on the system."
HOMEPAGE = "http://people.seas.harvard.edu/~apw/stress"
SECTION = "base"

LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

SRC_URI = "http://people.seas.harvard.edu/~apw/stress/${BPN}-${PV}.tar.gz"
SRC_URI[md5sum] = "890a4236dd1656792f3ef9a190cf99ef"
SRC_URI[sha256sum] = "057e4fc2a7706411e1014bf172e4f94b63a12f18412378fca8684ca92408825b"

inherit autotools

EXTRA_OECONF_append_mx6 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF_append_mx7 = "--host arm-poky-linux-gnueabi"
EXTRA_OECONF_append_mx8 = "--host aarch64-poky-linux"

do_configure (){
	oe_runconf
}

do_compile (){
	oe_runmake
}

do_install() {
	oe_runmake DESTDIR=${D} install
}

