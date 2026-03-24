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
        install -m 0644 ${ADDON_FILES_DIR}/sduart_nw61x_v1.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/sduart_nw61x_v1.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/sd_w61x_v1.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/sd_w61x_v1.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/uartspi_n61x_v1.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/uartspi_n61x_v1.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/uartuart_n61x_v1.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/uartuart_n61x_v1.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/IW612_QFN_iPA_power_table_DVT2_V1.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/IW612_QFN_iPA_power_table_DVT2_V1.bin
        install -m 0644 ${ADDON_FILES_DIR}/sduart_nw61x_v1_zb_dual_pan.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/sduart_nw61x_v1_zb_dual_pan.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/uartspi_n61x_v1_zb_dual_pan.bin.se ${IMAGE_ROOTFS}/lib/firmware/nxp/uartspi_n61x_v1_zb_dual_pan.bin.se
        install -m 0644 ${ADDON_FILES_DIR}/wifi_mod_para.conf ${IMAGE_ROOTFS}/lib/firmware/nxp/wifi_mod_para.conf
        install -m 0755 ${ADDON_FILES_DIR}/quectel-CM ${IMAGE_ROOTFS}/usr/bin/quectel-CM
        install -m 0755 ${ADDON_FILES_DIR}/adv-quectel-CM ${IMAGE_ROOTFS}/usr/bin/adv-quectel-CM
        mkdir -p ${IMAGE_ROOTFS}/lib/firmware/qca
        install -m 0644 ${ADDON_FILES_DIR}/nvm_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/nvm_usb_00000302.bin
        install -m 0644 ${ADDON_FILES_DIR}/rampatch_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/rampatch_usb_00000302.bin
#        install -m 0644 ${ADDON_FILES_DIR}/demos.json ${IMAGE_ROOTFS}/home/root/.nxp-demo-experience/demos.json
        mkdir -p ${IMAGE_ROOTFS}/etc
        install -m 0644 ${ADDON_FILES_DIR}/hostapd.VHT80.conf ${IMAGE_ROOTFS}/etc/hostapd.VHT80.conf
        install -m 0644 ${ADDON_FILES_DIR}/udhcpd.conf ${IMAGE_ROOTFS}/etc/udhcpd.conf
        mkdir -p ${IMAGE_ROOTFS}/etc/systemd/network/
        install -m 0644 ${ADDON_FILES_DIR}/10-wireless.network ${IMAGE_ROOTFS}/etc/systemd/network/10-wireless.network
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
