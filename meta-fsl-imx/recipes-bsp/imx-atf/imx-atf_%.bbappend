FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx8mmrom5721a1 = " ${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', ' file://0001-add-imx8mm-rom5721a1-1G-support.patch ', '', d)} "
SRC_URI:append:imx8mprsb3720a1 = " file://0001-imx8mp-rsb3720a1-change-debug-console-to-uart3.patch "
