MACHINEOVERRIDES =. "imx-boot-container:mx8:mx8m:mx8mp:"

require conf/machine/include/imx-base.inc
require conf/machine/include/tune-cortexa53.inc

MACHINE_FEATURES += "pci wifi bluetooth jailhouse"

# OP-TEE is also applicable to NXP BSP, mainline BSP seems not to have
# a full support for it yet.
MACHINE_FEATURES_append_use-nxp-bsp = " optee mrvl8997"

# Mainline kernel contains only one DTB file for
# Advantech imx8mp machine
KERNEL_DEVICETREE = " \
    freescale/${KERNEL_DEVICETREE_BASENAME}.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-lvds0-auo.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-lvds1-auo.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-lvds-dual.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-adv7535.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-basler.dtb \
    freescale/${KERNEL_DEVICETREE_BASENAME}-auog101uan02.dtb \
"

UBOOT_DTB_NAME = "${KERNEL_DEVICETREE_BASENAME}.dtb"

IMX_DEFAULT_BOOTLOADER_use-nxp-bsp = "u-boot-imx"
IMX_DEFAULT_BOOTLOADER_use-mainline-bsp = "u-boot-fslc"

UBOOT_SUFFIX = "bin"

WKS_FILE_DEPENDS_append = " imx-m7-demos"
IMAGE_BOOT_FILES += "imx8mp_m7_TCM_hello_world.bin \
                    imx8mp_m7_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin \
                    imx8mp_m7_TCM_rpmsg_lite_str_echo_rtos.bin \
                    imx8mp_m7_TCM_sai_low_power_audio.bin \
"

UBOOT_CONFIG ??= "6G"
UBOOT_CONFIG[6G] = "${UBOOT_CONFIG_BASENAME}_6G_defconfig,sdcard"
UBOOT_CONFIG[4G] = "${UBOOT_CONFIG_BASENAME}_4G_defconfig,sdcard"
UBOOT_CONFIG[FSPI_6G] = "${UBOOT_CONFIG_BASENAME}_6G_defconfig"
UBOOT_CONFIG[FSPI_4G] = "${UBOOT_CONFIG_BASENAME}_4G_defconfig"
UBOOT_CONFIG[mfgtool] = "${UBOOT_CONFIG_BASENAME}_6G_defconfig"

SPL_BINARY = "spl/u-boot-spl.bin"

ATF_PLATFORM = "imx8mp"
ATF_LOAD_ADDR = "0x970000"

# Extra firmware package name, that is required to build boot container for fslc bsp
IMX_EXTRA_FIRMWARE = "firmware-imx-8m"

IMXBOOT_TARGETS = \
    "${@bb.utils.contains_any('UBOOT_CONFIG', 'FSPI_6G FSPI_4G', '${IMXBOOT_TARGETS_BASENAME}_flexspi', \
                                                  '${IMXBOOT_TARGETS_BASENAME}', d)}"

IMX_BOOT_SOC_TARGET = "iMX8MP"

SERIAL_CONSOLES = "115200;ttymxc2"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = "all"
IMX_BOOT_SEEK = "32"

OPTEE_BIN_EXT = "8mp"
TEE_LOAD_ADDR = "0x56000000"

# Add additional firmware
MACHINE_FIRMWARE_append = " linux-firmware-ath10k"
