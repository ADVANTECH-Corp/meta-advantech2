ADDON_FILES_DIR:="${THISDIR}/files"

#Advantech package
require fsl-image-adv.inc


install_utils() {
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/nxp
	install -m 0644 ${ADDON_FILES_DIR}/pcieuart8997_combo_v4_6x17408.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart8997_combo_v4_6x17408.bin

	mkdir -p ${IMAGE_ROOTFS}/etc/systemd/network
	install -m 0644 ${ADDON_FILES_DIR}/10-mlan0.network ${IMAGE_ROOTFS}/etc/systemd/network/10-mlan0.network
}

update_profile() {
sed -i "\
s/# \"\\\e\[1~\"/\"\\\e\[1~\"/;\
s/# \"\\\e\[4~\"/\"\\\e\[4~\"/;\
s/# \"\\\e\[3~\"/\"\\\e\[3~\"/;\
s/# \"\\\e\[5~\"\: history/\"\\\e\[A\": history/;\
s/# \"\\\e\[6~\"\: history/\"\\\e\[B\": history/;\
" ${IMAGE_ROOTFS}/etc/inputrc

cat >> ${IMAGE_ROOTFS}/etc/profile << EOF
alias ls='/bin/ls --color=auto'
alias ll='ls -l'
alias la='ls -al'
alias l=ll
EOF
}

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "install_utils;"
