FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2024.04_6.6.36-2.1.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "887b2655d9c7c0d15f1eaeda5b3530a98f2771e9"

