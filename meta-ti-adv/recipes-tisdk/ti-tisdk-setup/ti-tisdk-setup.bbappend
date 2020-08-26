FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append = " \
    file://0001-create-sdcard-update-for-support-advantech-ota.patch \
"

UBOOT_ENV_am57xxrom7510a1 = "setup-uboot-env-am57xx-evm.sh"
UBOOT_ENV_am57xxrom7510a2 = "setup-uboot-env-am57xx-evm.sh"

