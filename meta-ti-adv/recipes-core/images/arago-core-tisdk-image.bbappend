
ADDON_MK_EMMC_DIR:="${THISDIR}/files/mk_emmc"

tisdk_add_mkemmc_script() {
        install -m 0755 ${ADDON_MK_EMMC_DIR}/mk-eMMC-boot.sh ${IMAGE_ROOTFS}/bin  

        if [ "${SOC_FAMILY}" = "ti-soc:ti33x" ]; then
                sed -i "262a  sysctl vm.min_free_kbytes=8192" ${IMAGE_ROOTFS}/bin/mk-eMMC-boot.sh
        fi 
}


ROOTFS_POSTPROCESS_COMMAND_append = "tisdk_add_mkemmc_script; "

