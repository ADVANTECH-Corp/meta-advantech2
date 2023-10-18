PACKAGES =+ "${PN}-rtl8188ee \
             ${PN}-rtl8821ae \
             "
LICENSE:${PN}-rtl8188ee = "Firmware-rtlwifi"
FILES:${PN}-rtl8188ee = " \
  /lib/firmware/rtlwifi/rtl8188efw.bin \
"
RDEPENDS:${PN}-rtl8188ee += "${PN}-rtl-license"


LICENSE:${PN}-rtl8821ae = "Firmware-rtlwifi"
FILES:${PN}-rtl8821ae = " \
  /lib/firmware/rtl_bt/rtl8821a_fw.bin \
"
RDEPENDS:${PN}-rtl8821ae += "${PN}-rtl-license"

