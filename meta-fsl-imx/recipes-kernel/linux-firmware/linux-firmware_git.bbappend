PACKAGES =+ "${PN}-rtl8188ee \
             ${PN}-rtl8821ae \
             "
LICENSE_${PN}-rtl8188ee = "Firmware-rtlwifi"
FILES_${PN}-rtl8188ee = " \
  /lib/firmware/rtlwifi/rtl8188efw.bin \
"
RDEPENDS_${PN}-rtl8188ee += "${PN}-rtl-license"


LICENSE_${PN}-rtl8821ae = "Firmware-rtlwifi"
FILES_${PN}-rtl8821ae = " \
  /lib/firmware/rtl_bt/rtl8821a_fw.bin \
"
RDEPENDS_${PN}-rtl8821ae += "${PN}-rtl-license"

