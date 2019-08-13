IMAGE_FEATURES += " package-management "
IMAGE_INSTALL += " haveged "

#Advantech package
require fsl-image-adv.inc

ROOTFS_POSTPROCESS_COMMAND += "update_profile ;"
ROOTFS_POSTPROCESS_COMMAND += "fix_haveged ;"

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

fix_haveged() {
    sed -i "s/\(ExecStart=.*\)/\1 --data=16/" ${IMAGE_ROOTFS}/lib/systemd/system/haveged.service
}
