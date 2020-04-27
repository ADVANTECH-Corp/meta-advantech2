FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "	file://0001-imx8mm-rom5721a1-disable-uart4-assign-to-m4.patch \
		file://0001-add-imx8mq-rom5720a1-support.patch \
"

SRC_URI_append_imx8qmrom7720a1 = " file://0001-imx8-board-reset.patch "

