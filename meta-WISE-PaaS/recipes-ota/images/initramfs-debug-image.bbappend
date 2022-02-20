DEPNEDS += "${PREFERRED_PROVIDER_virtual/kernel}"

BOOTIMG_PAGE_SIZE ?= "2048"
CACHE_PARTITION = "/dev/disk/by-label/cache"

modify_fstab() {
        echo "${CACHE_PARTITION}      /cache               ext4       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

ROOTFS_POSTPROCESS_COMMAND += " modify_fstab;"

# *.cpio.gz is moved to deploy dir at sstate_task_postfunc() in Yocto 2.5
# We have to generate recovery.img after that
sstate_task_postfunc_append() {
    from oe.utils import execute_pre_post_process
    post_mk_recovery_cmds = d.getVar("RECOVERY_POSTPROCESS_COMMAND")
    execute_pre_post_process(d, post_mk_recovery_cmds)
}

# [i.MX]
DEPENDS_imx += "android-tools-native"
BASE_ADDR_mx6 = "0x14000000"
BASE_ADDR_mx8 = "${@bb.utils.contains_any('UBOOT_CONFIG', '1G FSPI_1G', '0x46400000', '0x86400000', d)}"
SEC_OFFSET_mx6 = "0x00f00000"
SEC_OFFSET_mx8 = "0x01f00000"
RAMDISK_OFFSET_mx6 = "0x01000000"
RAMDISK_OFFSET_mx8 = "0x02000000"

# If DDR is less then 2G , BASE_ADDR need to be modified

mk_recovery_img_imx() {
    if [ -e ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz ]; then
        # Make sure only one dts files is selected
        export ALL_DTS_FILE="${KERNEL_DEVICETREE}"
        export FIRST_DTS_FILE=`echo ${ALL_DTS_FILE#*/} | cut -d ' ' -f 1`

        gunzip -f -k ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz

        mkbootimg --kernel ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} \
                  --ramdisk ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio \
                  --output ${DEPLOY_DIR_IMAGE}/recovery-${MACHINE}.img \
                  --second ${DEPLOY_DIR_IMAGE}/recovery-${FIRST_DTS_FILE} \
                  --pagesize ${BOOTIMG_PAGE_SIZE} \
                  --base ${BASE_ADDR} \
                  --second_offset ${SEC_OFFSET} \
                  --ramdisk_offset ${RAMDISK_OFFSET} \
                  --cmdline ""

        ln -sf recovery-${MACHINE}.img ${DEPLOY_DIR_IMAGE}/recovery.img
        rm ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio
    fi
}

RECOVERY_POSTPROCESS_COMMAND_imx += " mk_recovery_img_imx;"

# Utilities
# PACKAGE_INSTALL += " adv-ota android-tools base-files boottimes e2fsprogs-tune2fs udev-extraconf util-linux e2fsprogs-resize2fs e2fsprogs-e2fsck"
PACKAGE_INSTALL += " adv-ota android-tools base-files e2fsprogs-tune2fs udev-extraconf util-linux e2fsprogs-resize2fs e2fsprogs-e2fsck"

