MACHINEOVERRIDES =. "imx-boot-container:mx8:mx8m:mx8mm:"

require conf/machine/include/imx-base.inc
require conf/machine/include/tune-cortexa53.inc

MACHINE_FEATURES += "pci wifi bluetooth bcm43455 bcm4356"

# NXP BSP can consume BCM4359 and QCA9377 driver and firmware
# Since the firmware is not available publicly, and rather distributed
# under "Proprietary" license - we opt-out from using it in all BSPs
# and pin it to NXP BSP only
# OP-TEE is also applicable to NXP BSP, mainline BSP seems not to have
# a full support for it yet.
MACHINE_FEATURES_append_use-nxp-bsp = " optee bcm4359 qca9377"

KERNEL_DEVICETREE = " \
    freescale/${KERNEL_DEVICETREE_BASENAME}.dtb \
"
KERNEL_DEVICETREE_append_use-nxp-bsp = " \
	freescale/${KERNEL_DEVICETREE_BASENAME}.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-adv7535.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-m2-sdio.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-dsi2lvds-g150xgel05.dtb \
        freescale/${KERNEL_DEVICETREE_BASENAME}-dsi2lvds-g215hvn01.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-dsi2dp.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-auog101uan02.dtb \
        freescale/${KERNEL_DEVICETREE_BASENAME}-rpmsg.dtb \
	freescale/${KERNEL_DEVICETREE_BASENAME}-m2-i2s.dtb \
"
UBOOT_DTB_NAME = "${KERNEL_DEVICETREE_BASENAME}.dtb"

IMX_DEFAULT_BOOTLOADER_use-nxp-bsp = "u-boot-imx"
IMX_DEFAULT_BOOTLOADER_use-mainline-bsp = "u-boot-fslc"

UBOOT_SUFFIX = "bin"

UBOOT_CONFIG ??= "2G"
UBOOT_CONFIG[2G] = "${UBOOT_CONFIG_BASENAME}_2G_defconfig,sdcard"
UBOOT_CONFIG[1G] = "${UBOOT_CONFIG_BASENAME}_1G_defconfig,sdcard"
UBOOT_CONFIG[FSPI_2G] = "${UBOOT_CONFIG_BASENAME}_2G_fspi_defconfig"
UBOOT_CONFIG[FSPI_1G] = "${UBOOT_CONFIG_BASENAME}_1G_fspi_defconfig"

SPL_BINARY = "spl/u-boot-spl.bin"

ATF_PLATFORM = "imx8mm"
ATF_LOAD_ADDR = "0x920000"

# Extra firmware package name, that is required to build boot container for fslc bsp
IMX_EXTRA_FIRMWARE = "firmware-imx-8m"

IMXBOOT_TARGETS = "${@bb.utils.contains('UBOOT_CONFIG', 'FSPI_2G FSPI_1G', '${IMXBOOT_TARGETS_BASENAME}_flexspi', '${IMXBOOT_TARGETS_BASENAME}', d)}"

IMX_BOOT_SOC_TARGET = "iMX8MM"

SERIAL_CONSOLES = "115200;ttymxc1"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = "all"
IMX_BOOT_SEEK = "33"

OPTEE_BIN_EXT = "8mm"
TEE_LOAD_ADDR = "0xbe000000"

# Add additional firmware
MACHINE_FIRMWARE_append = " linux-firmware-ath10k"
