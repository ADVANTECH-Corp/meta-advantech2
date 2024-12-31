SUMMARY = "The shell scripts for RTD sensor test"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://AD7124_REG_CHN0.conf \
	   file://AD7124_REG_CHN1.conf \
	   file://rtd_ad7124_config.sh \
	   file://rtd_get_temperature.sh"

do_install() {
    install -d ${D}/tools/rtd
    install -m 755 ${WORKDIR}/*.sh ${D}/tools/rtd/
    install -m 755 ${WORKDIR}/*.conf ${D}/tools/rtd/
}

RDEPENDS:${PN} = "bash"

FILES:${PN} = "/tools/rtd"
