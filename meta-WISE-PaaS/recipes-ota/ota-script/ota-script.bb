SUMMARY = "Shell scripts for OTA update"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://do_update.sh \
		 file://do_update_mbed.sh \
	   file://ota-package.sh"

TOOLS = "do_update"
TOOLS_class-native = "ota-package"
TOOLS_class-nativesdk = "ota-package"

do_install() {
    mkdir -p ${D}/tools
    install -d ${D}/tools

    if echo ${TOOLS} | grep -q "do_update" ; then
        install -m 755 ${WORKDIR}/do_update.sh ${D}/tools/
        install -m 755 ${WORKDIR}/do_update_mbed.sh ${D}/tools/
    fi
    if echo ${TOOLS} | grep -q "ota-package" ; then
        install -m 755 ${WORKDIR}/ota-package.sh ${D}/tools/
    fi
}

RDEPENDS_${PN} += "bash"
FILES_${PN} = "/tools"

BBCLASSEXTEND = "native nativesdk"
