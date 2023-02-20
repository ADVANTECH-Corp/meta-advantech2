IMAGE_FEATURES += " package-management "
IMAGE_INSTALL += " haveged "
ADDON_FILES_DIR:="${THISDIR}/files"

#Advantech package
require fsl-image-adv.inc

#OTA
# Boot partition volume id
BOOTDD_VOLUME_ID = "boot"

# Boot partition size [in KiB]
BOOT_SPACE ?= "65536"

# Recovery partition size [in KiB]
RECOVERY_SPACE ?= "49152"

# Misc partition size [in KiB]
MISC_SPACE ?= "1024"

# Cache partition size [in KiB]
CACHE_SPACE ?= "786432"

# Rootfs partition size [in KiB]
ADV_ROOTFS_SIZE ?= "6291456"

# Barebox environment size [in KiB]
BAREBOX_ENV_SPACE ?= "512"

# Set alignment in KiB
IMAGE_ROOTFS_ALIGNMENT_mx6 ?= "4096"
IMAGE_ROOTFS_ALIGNMENT_mx7 ?= "4096"
IMAGE_ROOTFS_ALIGNMENT_mx8 ?= "8192"

SDCARD = "${DEPLOY_DIR_IMAGE}/${IMAGE_NAME}.rootfs.sdcard"
SDCARD_ROOTFS = "${WORKDIR}/deploy-imx-image-full-image-complete/${IMAGE_NAME}.rootfs.ext4"

MISC_IMAGE= "${DEPLOY_DIR_IMAGE}/misc"
CACHE_IMAGE= "${DEPLOY_DIR_IMAGE}/cache"
RECOVERY_IMAGE="${DEPLOY_DIR_IMAGE}/recovery"

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
	install -m 0755 ${ADDON_FILES_DIR}/bt-pair_imx8.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_send_imx8.sh ${IMAGE_ROOTFS}/usr/local/bin
	install -m 0755 ${ADDON_FILES_DIR}/bt_obexd_start_imx8.sh ${IMAGE_ROOTFS}/usr/local/bin
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
	install -m 0755 ${ADDON_FILES_DIR}/wifi_ant_isolation.txt ${IMAGE_ROOTFS}/lib/firmware/rtlwifi/rtl8821ae
	install -m 0644 ${ADDON_FILES_DIR}/sdsd8997_combo_v4.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/sdsd8997_combo_v4.bin
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/qca
	install -m 0644 ${ADDON_FILES_DIR}/nvm_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/nvm_usb_00000302.bin
	install -m 0644 ${ADDON_FILES_DIR}/rampatch_usb_00000302.bin ${IMAGE_ROOTFS}/lib/firmware/qca/rampatch_usb_00000302.bin
	mkdir -p ${IMAGE_ROOTFS}/lib/firmware/nxp
	install -m 0644 ${ADDON_FILES_DIR}/pcieuart9098_combo_v1.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart9098_combo_v1.bin
	install -m 0644 ${ADDON_FILES_DIR}/pcieuart8997_combo_v4_5x17283.bin ${IMAGE_ROOTFS}/lib/firmware/nxp/pcieuart8997_combo_v4_5x17283.bin
	install -m 0755 ${ADDON_FILES_DIR}/tpm-ST33HTP-Demo ${IMAGE_ROOTFS}/usr/bin/tpm-ST33HTP-Demo
	install -m 0755 ${ADDON_FILES_DIR}/quectel-CM ${IMAGE_ROOTFS}/usr/bin/quectel-CM
}

update_gpu() {
        install -m 0644 ${ADDON_FILES_DIR}/libGAL.so ${IMAGE_ROOTFS}/usr/lib
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

#OTA
#
# Generate the boot image with the boot scripts and required Device Tree
# files
_generate_boot_image() {
        local boot_part=$1

        # Create boot partition image
        BOOT_BLOCKS=$(LC_ALL=C parted -s ${SDCARD} unit b print \
                          | awk "/ $boot_part / { print substr(\$4, 1, length(\$4 -1)) / 1024 }")

        # mkdosfs will sometimes use FAT16 when it is not appropriate,
        # resulting in a boot failure from SYSLINUX. Use FAT32 for
        # images larger than 512MB, otherwise let mkdosfs decide.
        if [ $(expr $BOOT_BLOCKS / 1024) -gt 512 ]; then
                FATSIZE="-F 32"
        fi

        rm -f ${WORKDIR}/boot.img
        mkfs.vfat -n "${BOOTDD_VOLUME_ID}" -S 512 ${FATSIZE} -C ${WORKDIR}/boot.img $BOOT_BLOCKS

	# Copy all image boot files to boot partition: such as Image, dtb, optee, m4 images and firmwares
        if [ -n "${IMAGE_BOOT_FILES}" ]; then
            for IMAGE_FILE in ${IMAGE_BOOT_FILES}; do
                if [ -e "${DEPLOY_DIR_IMAGE}/${IMAGE_FILE}" ]; then
                    mcopy -i ${WORKDIR}/boot.img -s ${DEPLOY_DIR_IMAGE}/${IMAGE_FILE} ::/${IMAGE_FILE}
                else
                    bbfatal "${IMAGE_FILE} does not exist."
                fi
            done
        fi
}

#
# Create an image that can by written onto a SD card using dd for use
# with i.MX SoC family
#
# External variables needed:
#   ${SDCARD_ROOTFS}    - the rootfs image to incorporate
#   ${IMAGE_BOOTLOADER} - bootloader to use {u-boot, barebox}
#
# The disk layout used is:
#
#    0                      -> IMAGE_ROOTFS_ALIGNMENT         - reserved to bootloader (not partitioned)
#    IMAGE_ROOTFS_ALIGNMENT -> BOOT_SPACE                     - kernel and other data
#    BOOT_SPACE             -> SDIMG_SIZE                     - rootfs
#
#                                                     Default Free space = 1.3x
#                                                     Use IMAGE_OVERHEAD_FACTOR to add more space
#                                                     <--------->
#            4MiB               8MiB           SDIMG_ROOTFS                    4MiB
# <-----------------------> <----------> <----------------------> <------------------------------>
#  ------------------------ ------------ ------------------------ -------------------------------
# | IMAGE_ROOTFS_ALIGNMENT | BOOT_SPACE | ADV_ROOTFS_SIZE            |     IMAGE_ROOTFS_ALIGNMENT    |
#  ------------------------ ------------ ------------------------ -------------------------------
# ^                        ^            ^                        ^                               ^
# |                        |            |                        |                               |
# 0                      4096     4MiB +  8MiB       4MiB +  8Mib + SDIMG_ROOTFS   4MiB +  8MiB + SDIMG_ROOTFS + 4MiB
generate_imx_sdcard () {
	if [ -z "${SDCARD_ROOTFS}" ]; then
		bberror "SDCARD_ROOTFS is undefined. To use sdcard image from Freescale's BSP it needs to be defined."
		exit 1
	fi

	# Align boot partition and calculate total SD card image size
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	BOOT_SPACE_ALIGNED=$(expr ${BOOT_SPACE_ALIGNED} - ${BOOT_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	RECOVERY_SPACE_ALIGNED=$(expr ${RECOVERY_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	RECOVERY_SPACE_ALIGNED=$(expr ${RECOVERY_SPACE_ALIGNED} - ${RECOVERY_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	MISC_SPACE_ALIGNED=$(expr ${MISC_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	MISC_SPACE_ALIGNED=$(expr ${MISC_SPACE_ALIGNED} - ${MISC_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	CACHE_SPACE_ALIGNED=$(expr ${CACHE_SPACE} + ${IMAGE_ROOTFS_ALIGNMENT} - 1)
	CACHE_SPACE_ALIGNED=$(expr ${CACHE_SPACE_ALIGNED} - ${CACHE_SPACE_ALIGNED} % ${IMAGE_ROOTFS_ALIGNMENT})
	SDCARD_SIZE=$(expr ${IMAGE_ROOTFS_ALIGNMENT} + ${BOOT_SPACE_ALIGNED} + ${RECOVERY_SPACE_ALIGNED} + ${MISC_SPACE_ALIGNED} + ${CACHE_SPACE_ALIGNED} + ${ADV_ROOTFS_SIZE} + ${IMAGE_ROOTFS_ALIGNMENT})

	# Initialize a sparse file
	dd if=/dev/zero of=${SDCARD} bs=1 count=0 seek=$(expr 1024 \* ${SDCARD_SIZE})

	# [Advantech] Add partitions and format
	bbnote "[ADV] misc image"
	dd if=/dev/zero of=${MISC_IMAGE} bs=1 count=0 seek=$(expr 1024 \* ${MISC_SPACE_ALIGNED} - 1024)
	mkfs.ext2 -L misc ${MISC_IMAGE}
	bbnote "[ADV] cache image"
	dd if=/dev/zero of=${CACHE_IMAGE} bs=1 count=0 seek=$(expr 1024 \* ${CACHE_SPACE_ALIGNED} - 1024)
	mkfs.ext4 -L cache ${CACHE_IMAGE}
	bbnote "[ADV] recovery image"
	dd if=/dev/zero of=${RECOVERY_IMAGE} bs=1 count=0 seek=$(expr 1024 \* ${RECOVERY_SPACE_ALIGNED} - 1024)
	if [ -e ${DEPLOY_DIR_IMAGE}/recovery.img ];then
		dd if=${DEPLOY_DIR_IMAGE}/recovery.img of=${RECOVERY_IMAGE}
	fi

	# Create partition table
	# [Advantech] Change name of SDCARD parameter
	bbnote "generate_imx_sdcard() Prepare mklabel"
	parted -s ${SDCARD} mklabel msdos
	# boot
	parted -s ${SDCARD} unit KiB mkpart primary fat32 ${IMAGE_ROOTFS_ALIGNMENT} $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED})
	# rootfs
	parted -s ${SDCARD} unit KiB mkpart primary $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED} \+ ${CACHE_SPACE_ALIGNED}) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED} \+ ${CACHE_SPACE_ALIGNED} \+ ${ADV_ROOTFS_SIZE})
	# recovery
	parted -s ${SDCARD} unit KiB mkpart primary ext4 $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED}) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED})
	# extended
	parted -s ${SDCARD} unit KiB mkpart extended $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED}) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED} \+ ${CACHE_SPACE_ALIGNED})
	# misc
	parted -s ${SDCARD} unit KiB mkpart logical ext4 $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ 1) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED})
	# cache
	parted -s ${SDCARD} unit KiB mkpart logical ext4 $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED} \+ 1) $(expr ${IMAGE_ROOTFS_ALIGNMENT} \+ ${BOOT_SPACE_ALIGNED} \+ ${RECOVERY_SPACE_ALIGNED} \+ ${MISC_SPACE_ALIGNED} \+ ${CACHE_SPACE_ALIGNED})
	parted ${SDCARD} print

	# Burn bootloader
	case "${IMAGE_BOOTLOADER}" in
		imx-bootlets)
		bberror "The imx-bootlets is not supported for i.MX based machines"
		exit 1
		;;
                imx-boot)
                dd if=${DEPLOY_DIR_IMAGE}/imx-boot of=${SDCARD} conv=notrunc seek=${IMX_BOOT_SEEK} bs=1K
                ;;
                u-boot)
		if [ -n "${SPL_BINARY}" ]; then
                    if [ -n "${SPL_SEEK}" ]; then
                        dd if=${DEPLOY_DIR_IMAGE}/${SPL_BINARY} of=${SDCARD} conv=notrunc seek=${SPL_SEEK} bs=1K
                        dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=${UBOOT_SEEK} bs=1K
                    else
                        dd if=${DEPLOY_DIR_IMAGE}/${SPL_BINARY} of=${SDCARD} conv=notrunc seek=2 bs=512
                        dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=69 bs=1K
                    fi
		else
                    dd if=${DEPLOY_DIR_IMAGE}/u-boot-${MACHINE}.${UBOOT_SUFFIX_SDCARD} of=${SDCARD} conv=notrunc seek=2 bs=512
		fi
		;;
		barebox)
		dd if=${DEPLOY_DIR_IMAGE}/barebox-${MACHINE}.bin of=${SDCARD} conv=notrunc seek=1 skip=1 bs=512
		dd if=${DEPLOY_DIR_IMAGE}/bareboxenv-${MACHINE}.bin of=${SDCARD} conv=notrunc seek=1 bs=512k
		;;
		"")
		;;
		*)
		bberror "Unknown IMAGE_BOOTLOADER value"
		exit 1
		;;
	esac

	_generate_boot_image 1

	# Burn Partition
	# [Advantech] Change name of SDCARD parameter
	dd if=${WORKDIR}/boot.img of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	dd if=${RECOVERY_IMAGE} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024)
	dd if=${MISC_IMAGE} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024 + ${RECOVERY_SPACE_ALIGNED} \* 1024 + 1024)
	dd if=${CACHE_IMAGE} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024 + ${RECOVERY_SPACE_ALIGNED} \* 1024 + ${MISC_SPACE_ALIGNED} \* 1024 + 1024)
	e2label ${SDCARD_ROOTFS} rootfs
	dd if=${SDCARD_ROOTFS} of=${SDCARD} conv=notrunc,fsync seek=1 bs=$(expr ${BOOT_SPACE_ALIGNED} \* 1024 + ${IMAGE_ROOTFS_ALIGNMENT} \* 1024 + ${RECOVERY_SPACE_ALIGNED} \* 1024 + ${MISC_SPACE_ALIGNED} \* 1024 + ${CACHE_SPACE_ALIGNED} \* 1024)
}

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "fix_haveged ;"
ROOTFS_POSTPROCESS_COMMAND += "install_utils;"
ROOTFS_POSTPROCESS_COMMAND += "fbi_rootfs_postprocess;"
ROOTFS_POSTPROCESS_COMMAND_append_mx8 += "update_gpu;"

IMAGE_POSTPROCESS_COMMAND += "generate_imx_sdcard;"
