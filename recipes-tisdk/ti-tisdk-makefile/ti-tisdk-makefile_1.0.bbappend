
K3_UBOOT_MACHINE_R5_am62xx-rs10 = "am62x_rs10_r5_config"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_am62xx = " \
    file://0001-Advantech-added-rs10-Makefile-u-boot-spl.patch \
    file://0001-Advantech-Makefile-sysfw-image-rs10.patch \
"
