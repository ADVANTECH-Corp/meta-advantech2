
DESCRIPTION = "OPTEE OS"

# This appends to meta-fsl-bsp-release/imx/meta-bsp/recipes-security/opee/optee-os-imx_git.bb

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR_mx8mq	= "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8mm	= "${@d.getVar('MACHINE')[1:]}"

SRC_URI_append_imx8mqrom5720a1 += " file://0001-add-imx8mq-rom5720a1-support.patch "
SRC_URI_append_imx8qxprom5620a1 += " file://0002-add-imx8qxp-rom5620a1-support.patch "
SRC_URI_append_imx8qxprom3620a1 += " file://0003-add-imx8qxp-rom3620a1-support.patch "
SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-rom5721a1-1G-support.patch', '', d)}"
SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0001-add-imx8mm-rom5721a1-2G-support.patch', '', d)}"
