SUMMARY = "ADV hailo8-detection.sh-delete"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://detection.sh"


do_install_append() {
#        install -d ${D}/home/root/apps/detection
	rm ${D}/home/root/apps/detection/detection.sh
	install -m 0755 ${WORKDIR}/detection.sh ${D}/home/root/apps/detection/detection.sh
}

