# Advantech package
IMAGE_FEATURES += " ssh-server-openssh "
IMAGE_INSTALL += " modules-load "
IMAGE_INSTALL += " giflib stress fuse-exfat exfat-utils "
IMAGE_INSTALL += " ppp ntp e2fsprogs cronie e2fsprogs-e2fsck e2fsprogs-resize2fs inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL += " packagegroup-core-eclipse-debug "

IMAGE_INSTALL += " linux-firmware-ralink "
IMAGE_INSTALL += " linux-firmware-sd8897 "
IMAGE_INSTALL += " linux-firmware-ar3k "
IMAGE_INSTALL += " linux-firmware-rtl8821 "
IMAGE_INSTALL += " linux-firmware-rtl8723 rtl8723bs-bt "
IMAGE_INSTALL += " linux-firmware-rtl8168 "

# Native Compiler
IMAGE_INSTALL += " packagegroup-sdk-target "

# Tools
IMAGE_INSTALL += " \
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
    tcpdump \
    iperf3 \
    bridge-utils \
    poweronoff-script \
"

# Depends on projects
IMAGE_INSTALL:append:mx8-nxp-bsp = " si-script keyevent "
IMAGE_INSTALL:append:imx8mpepcr5710a1 = " add-led-ctrl \
                                   ecsd \
                                   "
#dhcp-server \
