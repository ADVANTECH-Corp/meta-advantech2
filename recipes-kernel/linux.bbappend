
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_am62xx-rs10 = " \
    file://0001-Advantech-added-rs10-ti-kernel.patch \
"
