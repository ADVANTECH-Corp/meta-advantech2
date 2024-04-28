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
IMAGE_INSTALL:append:imx6qrom5420a1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6qrom5420b1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6dlrom5420b1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6qrom3420a1 = " keyevent"
IMAGE_INSTALL:append:imx6qrom7420a1 = " keyevent"
IMAGE_INSTALL:append:imx6qprom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6qrom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6dlrom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL:append:imx6qrsb4410a1 = " lirc "
IMAGE_INSTALL:append:imx6qrsb4410a2 = " lirc "
IMAGE_INSTALL:append:mx8-nxp-bsp = " si-script keyevent "
IMAGE_INSTALL:append:imx8qmrom7720a1 = " wdt-button "
IMAGE_INSTALL:append:imx8mprsb3720a1 = " xauth \
                                   pylon \
                                   python3-pypylon \
                                   gentl-producer \
                                   "
IMAGE_INSTALL:append:imx8mmrsb3730a2 = " dns-add adv-overlay "
IMAGE_INSTALL:append:imx8mpepcr5710a1 = " xauth \
                                   pylon \
                                   python3-pypylon \
                                   gentl-producer \
                                   "
IMAGE_INSTALL:append:imx8ulprom2620a1 = " weston-exception "
# Browser
#IMAGE_INSTALL += " firefox "
