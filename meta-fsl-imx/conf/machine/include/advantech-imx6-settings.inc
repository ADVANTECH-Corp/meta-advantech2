# Provides the i.MX6 SABRE SD common settings

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/armv7a/tune-cortexa9.inc

UBOOT_BINARY_ADV = "u-boot_crc_adv.bin"

SOC_DEFAULT_WKS_FILE = "adv-imx-uboot-bootpart.wks.in"

IMAGE_BOOT_FILES = " \
    ${KERNEL_IMAGETYPE} \
    ${@make_dtb_boot_files(d)} \
"

