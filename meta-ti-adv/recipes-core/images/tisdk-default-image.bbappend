IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-graphics"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-gtk"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-qte"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-opencl"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-matrix"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-matrix-extra"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-multimedia"
IMAGE_INSTALL_remove = "chromium-ozone-wayland"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-hmi"
IMAGE_INSTALL_remove = "packagegroup-arago-tisdk-opencl-extra"

#Advantech package
require ti-image-adv.inc

OSTRO_LOCAL_GETTY ?= " \
    ${IMAGE_ROOTFS}${systemd_system_unitdir}/serial-getty@.service \
"

local_autologin () {
    sed -i -e 's/^\(ExecStart *=.*getty \)/\1--autologin root /' ${OSTRO_LOCAL_GETTY}
}

ROOTFS_POSTPROCESS_COMMAND_append_am62xx-rs10 = "local_autologin;"
