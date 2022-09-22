
DESCRIPTION = "OPTEE OS"

# This appends to meta-fsl-bsp-release/imx/meta-bsp/recipes-security/opee/optee-os-imx_git.bb

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR_mx8mp   = "${@d.getVar('MACHINE')[1:]}"

SRC_URI_append_imx8mprsb3720a1 += "${@bb.utils.contains_any('UBOOT_CONFIG', '6G FSPI_6G', 'file://0001-add-imx8mp-rsb3720a1-6G-support.patch', '', d)}"
