
BRANCH ?= "ti-u-boot-2018.01"
UBOOT_GIT_URI = "git://github.com/ADVANTECH-Corp/uboot-ti.git"
UBOOT_GIT_PROTOCOL = "git"
SRC_URI = "${UBOOT_GIT_URI};protocol=${UBOOT_GIT_PROTOCOL};branch=${BRANCH}"

SRCREV = "${AUTOREV}"

SRC_URI_remove = " \
    file://0001-HACK-firmware-ti_sci-remove-EXCLUSIVE-flag.patch \
    file://0001-arm-K3-Increase-SYSFW-maximum-size-for-HS.patch \
    file://0002-arm-K3-Avoid-use-of-MCU_PSRAM0-before-SYSFW-is-loade.patch \
    file://0003-arm-K3-Fix-fallthrough-in-switch-case.patch \
    file://0004-firmware-ti_sci-Add-support-for-firewall-management.patch \
    file://0005-firmware-ti_sci-Modify-auth_boot-TI-SCI-API-to-match.patch \
    file://0006-arm-mach-k3-Add-secure-device-support.patch \
    file://0007-configs-Add-a-config-for-AM65x-High-Security-EVM.patch \
    file://0008-doc-Update-info-on-using-K3-secure-devices.patch \
    file://0009-armV7R-K3-sysfw-loader-Move-secure-board-config-befo.patch \
    file://0010-firmware-ti_sci-increase-the-timeout-duration-to-3-s.patch \
"

