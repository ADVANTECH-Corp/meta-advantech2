FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCBRANCH = "adv_v2024.04_6.6.23_2.0.0_rs16"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "81612df08cd89750f1ea96a441fb4c360176639e"
