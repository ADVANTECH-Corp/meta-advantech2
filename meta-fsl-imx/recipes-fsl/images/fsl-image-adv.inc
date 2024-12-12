# Advantech package
IMAGE_FEATURES += " ssh-server-openssh "
IMAGE_INSTALL += " modules-load "
IMAGE_INSTALL += " giflib stress fuse-exfat exfat-utils "
IMAGE_INSTALL += " ppp ntp e2fsprogs cronie e2fsprogs-e2fsck e2fsprogs-resize2fs inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL += " packagegroup-core-eclipse-debug "

#IMAGE_INSTALL += " linux-firmware-rtl8188ee "
IMAGE_INSTALL += " linux-firmware-ralink "
IMAGE_INSTALL += " linux-firmware-sd8897 "
IMAGE_INSTALL += " linux-firmware-ar3k "
IMAGE_INSTALL += " linux-firmware-rtl8821 "
IMAGE_INSTALL += " linux-firmware-rtl8723 rtl8723bs-bt "
IMAGE_INSTALL += " linux-firmware-rtl8168 "

# Native Compiler
IMAGE_INSTALL += " packagegroup-sdk-target "


IMAGE_INSTALL:remove += " tensorflow-lite "

# Tools
IMAGE_INSTALL += " \
    enable485 \
    add-virtual-network \
    advresize-script \
    boottimes-script \
    st \
    quectel-script \
    3g-script \
    stress-script \
    xterm \
    mdio-tool \
    hwclock \
    libgpiod-tools \
"

# Depends on projects
IMAGE_INSTALL:append:imx8mmebcrs16a1 = " openthread openthread-iwxxx-spi otbr tayga otbr-iwxxx-spi \
					  bluez5 bluez5-noinst-tools bluez5-obex openobex obexftp glibc-gconv-utf-16 glibc-utils "
