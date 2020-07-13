DEPNEDS += "${PREFERRED_PROVIDER_virtual/kernel}"

BOOTIMG_PAGE_SIZE ?= "2048"
CACHE_PARTITION_mx6 = "/dev/disk/by-label/cache"
CACHE_PARTITION_dragonboard-410c = "/dev/disk/by-partlabel/cache"
CACHE_PARTITION_arago = "/dev/disk/by-label/cache"

modify_fstab() {
        echo "${CACHE_PARTITION}      /cache               ext4       nosuid,nodev,nomblk_io_submit 0 0" >> ${IMAGE_ROOTFS}/etc/fstab
}

ROOTFS_POSTPROCESS_COMMAND += " modify_fstab;"

# [i.MX]
DEPENDS_imx += "android-tools-native"

mk_recovery_img_imx() {

    mkbootimg --kernel ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} \
              --ramdisk ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz \
              --output ${DEPLOY_DIR_IMAGE}/recovery-${MACHINE}.img \
              --second ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-${KERNEL_DEVICETREE} \
              --pagesize ${BOOTIMG_PAGE_SIZE} \
              --base 0x14000000 \
              --cmdline ""

    ln -sf recovery-${MACHINE}.img ${DEPLOY_DIR_IMAGE}/recovery.img
}

IMAGE_POSTPROCESS_COMMAND_imx += " mk_recovery_img_imx ; "

# [Qcom APQ8016]
DEPENDS_dragonboard-410c += "skales-native"

mk_recovery_img_qcom() {

    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${STAGING_LIBDIR_NATIVE}"
    dtbTool -o ${DEPLOY_DIR_IMAGE}/dt-Image-${MACHINE}.img -s ${BOOTIMG_PAGE_SIZE} ${DEPLOY_DIR_IMAGE}
    mkbootimg_dtarg="--dt ${DEPLOY_DIR_IMAGE}/dt-Image-${MACHINE}.img"
    ln -sf dt-Image-${MACHINE}.img ${DEPLOY_DIR_IMAGE}/dt-Image.img

    mkbootimg --kernel ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE} \
              --ramdisk ${DEPLOY_DIR_IMAGE}/${PN}-${MACHINE}.cpio.gz \
              --output ${DEPLOY_DIR_IMAGE}/recovery-${MACHINE}.img \
              $mkbootimg_dtarg \
              --pagesize ${BOOTIMG_PAGE_SIZE} \
              --base 0 \
              --cmdline ""

    ln -sf recovery-${MACHINE}.img ${DEPLOY_DIR_IMAGE}/recovery.img
}

IMAGE_POSTPROCESS_COMMAND_dragonboard-410c += " mk_recovery_img_qcom ; "

# Utilities
PACKAGE_INSTALL += " adv-ota android-tools base-files boottimes e2fsprogs-tune2fs udev-extraconf util-linux e2fsprogs-resize2fs e2fsprogs-e2fsck"
