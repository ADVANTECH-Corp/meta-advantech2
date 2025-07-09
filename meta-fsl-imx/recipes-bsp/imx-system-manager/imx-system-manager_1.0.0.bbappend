FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

IMX_SYSTEM_MANAGER_SRC = "git://github.com/ADVANTECH-Corp/imx-sm.git;protocol=https"
SRCBRANCH = "lf-6.12.20-2.0.0-imx95-aom5521a2"
SRC_URI = "${IMX_SYSTEM_MANAGER_SRC};branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

