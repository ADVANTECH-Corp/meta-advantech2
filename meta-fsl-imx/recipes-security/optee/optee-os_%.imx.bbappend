DESCRIPTION = "OPTEE OS"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR_mx8mp-nxp-bsp = "${@d.getVar('MACHINE')[1:]}"

SRC_URI:append:imx8mprsb3720a2 = "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', ' file://0001-add-imx8mp-rsb3720a2-6G-support.patch ', '', d)}"
