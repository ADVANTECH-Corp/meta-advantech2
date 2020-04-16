
mv_init_to_sbin() {
#        sed -i "30a export PATH" ${IMAGE_ROOTFS}/init
        mv ${IMAGE_ROOTFS}/init ${IMAGE_ROOTFS}/sbin
}

ROOTFS_POSTPROCESS_COMMAND += "; mv_init_to_sbin;"


PACKAGE_INSTALL += " kernel-image-zimage \
        kernel-devicetree \
        kernel-modules \
"

PACKAGE_INSTALL_remove = "\
	android-tools \
"

