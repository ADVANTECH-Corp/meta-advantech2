FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "adv_v2021.04_5.10.35_2.0.0"
UBOOT_SRC = "git://github.com/ADVANTECH-Corp/uboot-imx.git;protocol=https"
SRCREV = "${AUTOREV}"

SRC_URI_append_imx8mprsb3720a1 += " 	file://0001-LFU-188-1-imx8m-soc-Relocate-u-boot-to-the-top-DDR-i.patch \
					file://0002-LFU-188-2-imx8mp_evk-Remove-reservation-for-MCU-RPMS.patch \
					file://0003-LFU-193-1-clk-imx8mp-Update-clock-tree-for-USB-relev.patch \
					file://0004-LFU-193-2-usb-xhci-imx8m-Update-iMX8MP-XHCI-driver-t.patch \
					file://0005-LFU-193-3-DTS-imx8mp-evk-Sync-the-USB-nodes-with-ker.patch \
					file://0006-LFU-193-4-imx8mp_evk-Remove-USB2-PWR-GPIO-control.patch \
					file://0007-LFU-193-5-DTS-imx8mp-Add-the-CMA-reserved-memory.patch \
					file://0009-LF-3892-2-imx8mp_evk-enable-usb-power-by-default.patch \
					file://0010-LF-3892-3-imx8mp-disable-snvs-and-sdma.patch \
					file://0012-LF-3892-5-imx8mn_evk-update-defconfig-and-code-for-S.patch \
					file://0013-LF-3892-6-imx8mp_evk-update-defconfig-and-code-for-S.patch"

do_deploy_append_mx6() {
    install -d ${DEPLOYDIR}
    install ${B}/${config}/u-boot_crc.bin.crc ${DEPLOYDIR}/u-boot_crc.bin.crc
    install ${B}/${config}/u-boot_crc.bin ${DEPLOYDIR}/u-boot_crc.bin
    install ${B}/${config}/u-boot_crc_adv.bin ${DEPLOYDIR}/u-boot_crc_adv.bin
}
