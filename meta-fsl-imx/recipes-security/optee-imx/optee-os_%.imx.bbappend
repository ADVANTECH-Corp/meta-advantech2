DESCRIPTION = "OPTEE OS"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR:mx8mm-nxp-bsp = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8mp-nxp-bsp = "${@d.getVar('MACHINE')[1:]}"

SRC_URI:append:imx8mmrom5721a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', ' file://0001-add-imx8mm-rom5721a1-2G-support.patch ', d)}"
SRC_URI:append:imx8mprom5722a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', ' file://0001-add-imx8mp-rom5722a1-6G-support.patch ', ' file://0001-add-imx8mp-rom5722a1-4G-support.patch', d)}"
SRC_URI:append:imx8mprsb3720a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', ' file://0001-add-imx8mp-rsb3720a1-2G-support.patch ', ' file://0001-add-imx8mp-rsb3720a1-6G-support.patch ', d)}"
