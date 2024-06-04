DESCRIPTION = "OPTEE OS"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR:mx8mm-nxp-bsp = "${@d.getVar('MACHINE')[1:]}"

SRC_URI:append:imx8mmrom5721a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', ' file://0001-add-imx8mm-rom5721a1-2G-support.patch ', d)}"
SRC_URI:append:imx8mmebcrs08a2 = "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', ' file://0001-add-imx8mm-ebcrs08a2-2G-support.patch ', '', d)}"
SRC_URI:append:imx8mmebcrs12a1 = "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', ' file://0001-add-imx8mm-ebcrs12a1-4G-support.patch ', '', d)}"
