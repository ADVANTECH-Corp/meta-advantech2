#
# Copyright (C) 2016 Wind River Systems, Inc.
#

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

RDEPENDS_${PN} = "bash"

SRC_URI += "git://github.com/lwfinger/rtl8723bs_bt.git \
	   "
SRCREV = "07cda47e386f7bece859323f55b5a6a0df51c63b"	
S = "${WORKDIR}/git"

INSANE_SKIP_${PN} = "ldflags"

do_compile(){
	$CC -o rtk_hciattach hciattach.c hciattach_rtk.c
}

do_install(){
	install -d ${D}/lib/firmware/rtl_bt
	install -d ${D}/opt/rtl8723bs_bt
	install -m 0755 rtlbt_* ${D}/lib/firmware/rtl_bt
	install -m 0755 rtk_hciattach ${D}/opt/rtl8723bs_bt
	install -m 0755 start_bt.sh ${D}/opt/rtl8723bs_bt
}

FILES_${PN} = "/lib/firmware \
	     /opt/rtl8723bs_bt \
	     "
