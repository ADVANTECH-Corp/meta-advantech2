
DESCRIPTION = "OPTEE OS"

# This appends to meta-fsl-bsp-release/imx/meta-bsp/recipes-security/opee/optee-os-imx_git.bb

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

PLATFORM_FLAVOR_mx8mq	= "${@d.getVar('MACHINE')[1:]}"

SRC_URI += " file://0001-add-imx8mq-rom5720a1-support.patch \
             file://0002-add-imx8qxp-rom5620a1-support.patch \
"
