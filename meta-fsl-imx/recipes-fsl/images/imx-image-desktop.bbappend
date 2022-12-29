ADDON_FILES_DIR:="${THISDIR}/files"

install_utils() {
	mkdir -p ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/expand-root-partition.sh ${IMAGE_ROOTFS}/usr/local/bin
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
