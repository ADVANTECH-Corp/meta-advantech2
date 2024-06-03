FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx8mmrom5721a1 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', '', d)} "
SRC_URI:append:imx8mmebcrs08a2 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', ' file://0001-add-imx8mmrs08a2-bl31-imx_system_off.patch ', '', d)} "
SRC_URI:append:imx8mmebcrs12a1 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '4G FSPI_4G', ' file://0001-add-imx8mmrs12a1-bl31-imx_system_off.patch ', ' file://0001-add-imx8mmrs12a1-bl31-imx_system_off.patch ', d)} "
