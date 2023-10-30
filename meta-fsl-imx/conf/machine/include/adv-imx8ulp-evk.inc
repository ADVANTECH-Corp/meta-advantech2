MACHINEOVERRIDES =. "mx8:mx8ulp:"

require conf/machine/include/imx-base.inc
require conf/machine/include/arm/armv8a/tune-cortexa35.inc

MACHINE_GSTREAMER_1_0_PLUGIN ?= "imx-gst1.0-plugin"

MACHINE_FEATURES += "pci wifi bluetooth optee jailhouse"

KERNEL_DEVICETREE = " \
    freescale/${KERNEL_DEVICETREE_BASENAME}.dtb \
"

IMX_DEFAULT_BOOTLOADER:use-nxp-bsp = "u-boot-imx"
IMX_DEFAULT_BOOTLOADER:use-mainline-bsp = "u-boot-fslc"

LOADADDR = ""
UBOOT_SUFFIX = "bin"
UBOOT_MAKE_TARGET = ""

SPL_BINARY = "spl/u-boot-spl.bin"

UBOOT_CONFIG ??= "2G"
UBOOT_CONFIG[2G]   = "${UBOOT_CONFIG_BASENAME}_2G_defconfig,sdcard"
UBOOT_CONFIG[FSPI_2G] = "${UBOOT_CONFIG_BASENAME}_2G_defconfig"
UBOOT_CONFIG[ND_2G]   = "${UBOOT_CONFIG_BASENAME}_2G_nd_defconfig"

# Set ATF platform name
ATF_PLATFORM = "imx8ulp"

IMXBOOT_TARGETS_SD   = "flash_singleboot_m33 flash_singleboot flash_dualboot_m33 flash_dualboot"
IMXBOOT_TARGETS_FSPI = "flash_singleboot_m33_flexspi flash_dualboot_flexspi"
IMXBOOT_TARGETS_ND   = "flash_singleboot_m33"

IMXBOOT_TARGETS = "${@bb.utils.contains('UBOOT_CONFIG',   '2G', '${IMXBOOT_TARGETS_SD}', \
                      bb.utils.contains('UBOOT_CONFIG', 'FSPI_2G', '${IMXBOOT_TARGETS_FSPI}', \
                                                                '${IMXBOOT_TARGETS_ND}', d), d)}"

IMX_BOOT_SOC_TARGET = "iMX8ULP"
IMX_BOOT_SEEK = "32"

# We have to disable SERIAL_CONSOLE due to auto-serial-console
SERIAL_CONSOLES = "115200;ttyLP1"

# Add additional firmware
MACHINE_FIRMWARE:append = " firmware-imx-epdc"