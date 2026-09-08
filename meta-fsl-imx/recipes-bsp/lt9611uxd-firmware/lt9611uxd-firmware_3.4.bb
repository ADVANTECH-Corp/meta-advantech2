SUMMARY = "Firmware for the Lontium LT9611UXD DSI to HDMI bridge"
DESCRIPTION = "The LT9611UXD runs its own MCU and has no firmware of its \
own until one is flashed into its embedded SPI flash, which the bridge \
driver does on the first boot after checking the version the chip reports \
in E080/E081. This is the image from the vendor release \
LT9611UXD_Linux_Driver_v3.4."
SECTION = "base"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Proprietary;md5=0557f9d92cf58f2ccdd50f62f8ac0b28"

SRC_URI = "file://LT9611UXD.bin"

inherit allarch

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware
    install -m 0644 ${UNPACKDIR}/LT9611UXD.bin ${D}${nonarch_base_libdir}/firmware/LT9611UXD.bin
}

FILES:${PN} = "${nonarch_base_libdir}/firmware/LT9611UXD.bin"

COMPATIBLE_MACHINE = "imx95aom5521a2"
