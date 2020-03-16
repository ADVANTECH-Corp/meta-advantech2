IMAGE_FEATURES += " package-management "
IMAGE_INSTALL += " haveged "
ADDON_FILES_DIR:="${THISDIR}/files"

#Advantech package
require fsl-image-adv.inc

install_utils() {
	mkdir -p ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_pair.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_send.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_obexd_start.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_obexd_stop.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/mlanutl ${IMAGE_ROOTFS}/usr/local/bin
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
	install -m 0755 ${ADDON_FILES_DIR}/wifi_ant_isolation.txt ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/mrvl
	install -m 0644 ${ADDON_FILES_DIR}/sdsd8997_combo_v4.bin ${IMAGE_ROOTFS}/lib/firmware/mrvl/sd8997_uapsta.bin
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
shopt -s checkwinsize
resize > /dev/null
EOF
}

fix_haveged() {
    sed -i "s/\(ExecStart=.*\)/\1 --data=16/" ${IMAGE_ROOTFS}/lib/systemd/system/haveged.service
}

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "fix_haveged ;"
ROOTFS_POSTPROCESS_COMMAND += "install_utils;"
