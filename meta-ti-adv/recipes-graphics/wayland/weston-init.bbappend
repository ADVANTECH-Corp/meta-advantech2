FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_ti33x = " \
    file://0001-weston-init-advantech.patch \
"

