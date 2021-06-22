FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_imx8qmrom7720a1 += " file://0001-imx8-board-reset.patch "
SRC_URI_append_imx8mqrom5720a1 += " file://0001-add-imx8mq-rom5720a1-support.patch "
SRC_URI_append_imx8mmrom5721a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-rom5721a1-1G-support.patch', '', d)} "
SRC_URI_append_imx8mmrom5721a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0002-add-imx8mm-rom5721a1-2G-support.patch', '', d)} "
#SRC_URI_append_imx8mmebcrs08a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-ebcrs08a1-1G-support.patch', '', d)} "
SRC_URI_append_imx8mmebcrs08a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', 'file://0001-add-imx8mm-ebcrs08a1-1G-support-new.patch', '', d)} "
# SRC_URI_append_imx8mmebcrs08a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0002-add-imx8mm-ebcrs08a1-2G-support.patch', '', d)} "
SRC_URI_append_imx8mmebcrs08a1 += " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', 'file://0002-add-imx8mm-ebcrs08a1-2G-support-new.patch', '', d)} "
SRC_URI_append_imx8mmebcrs08a1 += " file://0003-change_console_to_uart4.patch "



