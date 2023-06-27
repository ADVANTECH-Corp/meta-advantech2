MACHINEOVERRIDES =. "mx8mp:"

# FIXME: u-boot-imx should be converted to `binman` and then we can
# avoid this specific overrides and handle it in a generic way.
MACHINEOVERRIDES =. "${@bb.utils.contains('IMX_DEFAULT_BOOTLOADER', 'u-boot-imx', '', 'imx-boot-container:', d)}"

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/armv8a/tune-cortexa53.inc

# Mainline BSP defaults to "generic" cortexa53 configuration,
# adjust it here to include crypto extension which enables
# inline NEON and FPU code generation
DEFAULTTUNE:use-mainline-bsp = "cortexa53-crypto"

MACHINE_FEATURES += "pci wifi bluetooth"

# NXP BSP can consume proprietary jailhouse and Marvell drivers
# OP-TEE is also applicable to NXP BSP, mainline BSP seems not to have
# a full support for it yet.
MACHINE_FEATURES:append:use-nxp-bsp = " optee jailhouse mrvl8997"

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

IMX_DEFAULT_BOOTLOADER:use-nxp-bsp = "u-boot-imx"
IMX_DEFAULT_BOOTLOADER:use-mainline-bsp = "u-boot-fslc"

UBOOT_SUFFIX = "bin"

WKS_FILE_DEPENDS:append = " imx-m7-demos"
IMAGE_BOOT_FILES += "imx8mp_m7_TCM_hello_world.bin \
    imx8mp_m7_TCM_low_power_voice.bin \
    imx8mp_m7_TCM_low_power_wakeword.bin \
    imx8mp_m7_TCM_rpmsg_lite_pingpong_rtos_linux_remote.bin \
    imx8mp_m7_TCM_rpmsg_lite_str_echo_rtos.bin \
    imx8mp_m7_TCM_sai_low_power_audio.bin \
"

SPL_BINARY = "spl/u-boot-spl.bin"

ATF_PLATFORM = "imx8mp"

IMXBOOT_TARGETS = \
    "${@bb.utils.contains('UBOOT_CONFIG', 'FSPI_2G FSPI_6G', '${IMXBOOT_TARGETS_BASENAME}_flexspi', \
                                                  '${IMXBOOT_TARGETS_BASENAME}', d)}"

IMX_BOOT_SOC_TARGET = "iMX8MP"

SERIAL_CONSOLES = "115200;ttymxc1"

# Add support for Syslinux to mainline BSP.
# U-Boot has the Distro Boot mode enabled by default, which
# require that either Syslinux to be enabled, or a boot script
# to be used to define the boot process.
# We opt-in for Syslinux, since it is designated as a preferred
# distro boot mode according to the U-Boot documentation.
UBOOT_EXTLINUX:use-mainline-bsp = "1"
UBOOT_EXTLINUX_LABELS:use-mainline-bsp = "default"
UBOOT_EXTLINUX_DEFAULT_LABEL:use-mainline-bsp = "i.MX8M Plus EVK"

UBOOT_EXTLINUX_MENU_DESCRIPTION:default:use-mainline-bsp = "i.MX8M Plus EVK"
UBOOT_EXTLINUX_FDT:default:use-mainline-bsp     = "../${KERNEL_DEVICETREE_BASENAME}.dtb"
UBOOT_EXTLINUX_CONSOLE:default:use-mainline-bsp = "console=${console}"
UBOOT_EXTLINUX_ROOT:default:use-mainline-bsp    = "root=/dev/mmcblk1p2"

# Add extlinux.conf to the lis of files, which are deployed onto the
# boot partition
IMAGE_BOOT_FILES:append:use-mainline-bsp = " extlinux.conf;extlinux/extlinux.conf"

LOADADDR = ""
UBOOT_MAKE_TARGET = "all"
IMX_BOOT_SEEK = "32"

OPTEE_BIN_EXT = "8mp"
TEE_LOAD_ADDR = "0x56000000"

# Add additional firmware
MACHINE_FIRMWARE:append = " linux-firmware-ath10k"
