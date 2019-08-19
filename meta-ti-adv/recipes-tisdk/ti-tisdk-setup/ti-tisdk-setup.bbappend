FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://0001-create-sdcard-update-for-support-advantech-ota.patch \
"

