
K3_UBOOT_MACHINE_R5_am62xx-rs10 = "am62x_evm_r5_config"

SYSFW_SOC_am62xx-rs10 = am62x

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_am62xx = " \
    file://0001-Advantech-added-rs10-Makefile-u-boot-spl.patch \
