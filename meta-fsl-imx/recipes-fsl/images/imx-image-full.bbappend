IMAGE_FEATURES += " package-management "
IMAGE_INSTALL += " haveged "
ADDON_FILES_DIR:="${THISDIR}/files"

#Advantech package
require fsl-image-adv.inc

fbi_rootfs_postprocess() {
        crond_conf=${IMAGE_ROOTFS}/var/spool/cron/root
        echo '0 0-23/12 * * * /sbin/hwclock --hctosys' >> $crond_conf
}

install_utils() {
        mkdir -p ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/bt_pair.sh ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/bt_send.sh ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/bt_obexd_start.sh ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/bt_obexd_stop.sh ${IMAGE_ROOTFS}/usr/local/bin
        install -m 0755 ${ADDON_FILES_DIR}/mlanutl ${IMAGE_ROOTFS}/usr/local/bin
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
        install -m 0755 ${ADDON_FILES_DIR}/wifi_ant_isolation.txt ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
        install -m 0644 ${ADDON_FILES_DIR}/sdsd8997_combo_v4.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/sdsd8997_combo_v4.bin
        install -m 0644 ${ADDON_FILES_DIR}/pcieuart8997_combo_v4_mxm5x17391.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart8997_combo_v4_mxm5x17391.bin
        install -m 0755 ${ADDON_FILES_DIR}/quectel-CM ${IMAGE_ROOTFS}/usr/bin/quectel-CM
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/qca
        install -m 0644 ${ADDON_FILES_DIR}/nvm_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/nvm_usb_00000302.bin
        install -m 0644 ${ADDON_FILES_DIR}/rampatch_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/rampatch_usb_00000302.bin
        install -m 0644 ${ADDON_FILES_DIR}/demos.json ${IMAGE_ROOTFS}/home/root/.nxp-demo-experience/demos.json
        mkdir -p ${IMAGE_ROOTFS}/lib/modules/rtl8822cu
        install -m 0755 ${ADDON_FILES_DIR}/8822cu.ko ${IMAGE_ROOTFS}/lib/modules/rtl8822cu
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/rtl_bt
        install -m 0755 ${ADDON_FILES_DIR}/rtl8822cu_fw.bin ${IMAGE_ROOTFS}/lib/firmware/rtl_bt
        install -m 0755 ${ADDON_FILES_DIR}/rtl8822cu_config.bin ${IMAGE_ROOTFS}/lib/firmware/rtl_bt
}

update_profile() {
sed -i "\
s/# \"\\\e\[1~\"/\"\\\e\[1~\"/;\
s/# \"\\\e\[4~\"/\"\\\e\[4~\"/;\
s/# \"\\\e\[3~\"/\"\\\e\[3~\"/;\
s/# \"\\\e\[5~\"\: history/\"\\\e\[A\": history/;\
s/# \"\\\e\[6~\"\: history/\"\\\e\[B\": history/;\
" ${IMAGE_ROOTFS}/etc/inputrc

cat >> ${IMAGE_ROOTFS}/etc/profile << EOB
alias ls='/bin/ls --color=auto'
alias ll='ls -l'
alias la='ls -al'
alias l=ll
shopt -s checkwinsize
resize > /dev/null
EOB
}

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "install_utils;"
ROOTFS_POSTPROCESS_COMMAND += "fbi_rootfs_postprocess;"
