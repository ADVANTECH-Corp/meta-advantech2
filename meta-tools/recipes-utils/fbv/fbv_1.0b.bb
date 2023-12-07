SUMMARY = "fbv is a very simple graphic file viewer"
DESCRIPTION = "fbv is a very simple graphic file viewer for the framebuffer console, capable of displaying GIF, JPEG, PNG and BMP files."
HOMEPAGE = "http://freecode.com/projects/fbv"
SECTION = "base"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=130f9d9dddfebd2c6ff59165f066e41c"

SRC_URI = "http://s-tech.elsat.net.pl/fbv/${BPN}-${PV}.tar.gz \
           file://fbv_fix.patch \
           file://fbv_multi_fb.patch"

SRC_URI[md5sum] = "3e466375b930ec22be44f1041e77b55d"
SRC_URI[sha256sum] = "9b55b9dafd5eb01562060d860e267e309a1876e8ba5ce4d3303484b94129ab3c"

do_configure (){
	./configure --libs="-lgif -ljpeg -lpng" --prefix /usr
}

EXTRA_OEMAKE = "-e MAKEFLAGS="

do_compile (){
	oe_runmake
}

do_install() {
	mkdir -p ${D}/usr/bin
	mkdir -p ${D}/usr/share/man/man1
	oe_runmake DESTDIR=${D} install
}

DEPENDS = "giflib jpeg libpng"

