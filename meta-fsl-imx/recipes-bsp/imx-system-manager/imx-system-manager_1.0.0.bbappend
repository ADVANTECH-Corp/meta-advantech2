FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

IMX_SYSTEM_MANAGER_SRC = "git://github.com/ADVANTECH-Corp/imx-sm.git;protocol=https"
SRCBRANCH = "lf-6.6.3-imx95-er2-aom3511a1"
SRC_URI = "${IMX_SYSTEM_MANAGER_SRC};branch=${SRCBRANCH}"
SRCREV = "${AUTOREV}"

