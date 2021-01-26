FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_arago = "file://adv-ota_TI.sh \
			file://adv-backup.sh \
"

do_install_append() {

    if [ -e ${D}/tools/adv-ota.sh ] ; then
        rm ${D}/tools/adv-ota.sh
    fi

    if [ -e ${WORKDIR}/adv-ota_TI.sh ] ; then
        install -m 755 ${WORKDIR}/adv-ota_TI.sh ${D}/tools/adv-ota.sh
    fi

    if [ -e ${WORKDIR}/adv-backup.sh ] ; then
        install -m 755 ${WORKDIR}/adv-backup.sh ${D}/tools/adv-backup.sh
    fi

}

