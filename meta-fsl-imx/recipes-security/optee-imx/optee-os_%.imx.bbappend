
DESCRIPTION = "OPTEE OS"

# This appends to meta-fsl-bsp-release/imx/meta-bsp/recipes-security/opee/optee-os-imx_git.bb

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR_mx8mq   = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8mm   = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8mp   = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8qm   = "${@d.getVar('MACHINE')[1:]}"
PLATFORM_FLAVOR_mx8qxp   = "${@d.getVar('MACHINE')[1:]}"

SRC_URI_append_imx8mqrom5720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G', 'file://0001-add-imx8mq-rom5720a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-rom5721a1-1G-support.patch', '', d)}"
SRC_URI_append_imx8mmrom5721a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0001-add-imx8mm-rom5721a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8qxprom5620a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0002-add-imx8qxp-rom5620a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8qxprom3620a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0003-add-imx8qxp-rom3620a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8qmrom7720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', 'file://0004-add-imx8qm-rom7720a1-4G-support.patch', '', d)}"
SRC_URI_append_imx8mprsb3720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0005-add-imx8mp-rsb3720a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8mprsb3720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', 'file://0005-add-imx8mp-rsb3720a1-4G-support.patch', '', d)}"
SRC_URI_append_imx8mprsb3720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', 'file://0005-add-imx8mp-rsb3720a1-6G-support.patch', '', d)}"
SRC_URI_append_imx8mpepcr5710a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0005-add-imx8mp-epcr5710a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8mpepcr5710a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', 'file://0005-add-imx8mp-epcr5710a1-4G-support.patch', '', d)}"
SRC_URI_append_imx8mpepcr5710a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', 'file://0005-add-imx8mp-epcr5710a1-6G-support.patch', '', d)}"
SRC_URI_append_imx8mprom5722a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0006-add-imx8mp-rom5722a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8mprom5722a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', 'file://0006-add-imx8mp-rom5722a1-4G-support.patch', '', d)}"
SRC_URI_append_imx8mprom5722a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', 'file://0006-add-imx8mp-rom5722a1-6G-support.patch', '', d)}"
SRC_URI_append_imx8mmrsb3730a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0001-add-imx8mm-rsb3730a1-2G-support.patch', '', d)}"
SRC_URI_append_imx8mmrsb3730a2 += "${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0007-add-imx8mm-rsb3730a2-2G-support.patch', '', d)}"
SRC_URI_append_imx8mmrsb3730a2 += "${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', 'file://0007-add-imx8mm-rsb3730a2-4G-support.patch', '', d)}"
