FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2023.04_6.6.3-1.0.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

