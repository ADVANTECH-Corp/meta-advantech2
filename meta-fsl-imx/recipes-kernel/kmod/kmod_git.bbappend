FILES_DIR:="${THISDIR}/files"

do_install_append() {
        install -m 0755    ${FILES_DIR}/advantech.conf       ${D}${sysconfdir}/modprobe.d
}





