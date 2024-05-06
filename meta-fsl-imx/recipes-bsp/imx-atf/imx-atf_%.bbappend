FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx8mmrom5721a1 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', '', d)} "
SRC_URI:append:imx8mqrom5720a1 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', ' file://0001-add-imx8mq-rom5720a1-2G-support.patch ', '', d)} "
SRC_URI:append:imx8mmrsb3730a2 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '2G FSPI_2G', ' file://0001-add-imx8mm-rsb3730a2-2G-support.patch ', ' file://0001-add-imx8mm-rsb3730a2-4G-support.patch ', d)} "
