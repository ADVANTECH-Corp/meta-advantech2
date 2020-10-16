FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append_imx8mmrom5721a1 = " file://0001-imx8mm-rom5721a1-disable-uart4-assign-to-m4.patch "
SRC_URI_append_imx8mqrom5720a1 = " file://0001-add-imx8mq-rom5720a1-support.patch "
SRC_URI_append_imx8qmrom7720a1 = " file://0001-imx8-board-reset.patch "
SRC_URI_append_imx8mprsb3720a1 = " file://0001-imx8mp-rsb3720a1-change-debug-console-to-uart3.patch "

