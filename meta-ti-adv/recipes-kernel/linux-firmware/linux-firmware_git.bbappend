
PACKAGES =+ "${PN}-bcm43241b4 \
            "

LICENSE_${PN}-bcm43241b4 = "Firmware-broadcom_bcm43xx"
FILES_${PN}-bcm43241b4 = " \
  ${nonarch_base_libdir}/firmware/brcm/brcmfmac43241b4-sdio.bin \
"
RDEPENDS_${PN}-bcm43241b4 += "${PN}-broadcom-license"




