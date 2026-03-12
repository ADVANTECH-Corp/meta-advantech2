FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:imx95aom5521a2 = " file://0001-imx95-atf-power-Use-SCMI-full-shutdown-state-to-keep.patch \
                                  file://0002-imx95-atf-power-Use-SCMI-full-reset-state-to-keep.patch "

