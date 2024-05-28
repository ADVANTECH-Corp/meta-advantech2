ADDON_FILES_DIR:="${THISDIR}/files"

require fsl-image-adv-desktop.inc

install_utils() {
        mkdir -p ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/expand-root-partition.sh ${IMAGE_ROOTFS}/usr/local/bin

        mkdir -p ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0644 ${ADDON_FILES_DIR}/pcieuart8997_combo_v4_6x17408.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart8997_combo_v4_6x17408.bin
        install -m 0644 ${ADDON_FILES_DIR}/pcieuart9098_combo_v1.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart9098_combo_v1.bin
        install -m 0755 ${ADDON_FILES_DIR}/tpm-ST33HTP-Demo ${IMAGE_ROOTFS}/usr/bin/tpm-ST33HTP-Demo



}


update_profile() {
sed -i "\
s/# \"\\\e\[1~\"/\"\\\e\[1~\"/;\
s/# \"\\\e\[4~\"/\"\\\e\[4~\"/;\
s/# \"\\\e\[3~\"/\"\\\e\[3~\"/;\
s/# \"\\\e\[5~\"\: history/\"\\\e\[A\": history/;\
s/# \"\\\e\[6~\"\: history/\"\\\e\[B\": history/;\
" ${IMAGE_ROOTFS}/etc/inputrc
}

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "install_utils;"
