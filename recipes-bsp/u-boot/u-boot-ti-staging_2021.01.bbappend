
BRANCH = "am62x-u-boot-2021.01_08.06.00.007"
UBOOT_GIT_URI = "git://github.com/ADVANTECH-Corp/uboot-ti.git"
UBOOT_GIT_PROTOCOL = "git"
SRC_URI = "${UBOOT_GIT_URI};protocol=${UBOOT_GIT_PROTOCOL};branch=${BRANCH}"

SRCREV = "${AUTOREV}"