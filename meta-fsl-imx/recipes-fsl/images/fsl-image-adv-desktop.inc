# Advantech package
IMAGE_FEATURES += " ssh-server-openssh "
#IMAGE_INSTALL += " modules-load "
#IMAGE_INSTALL += " giflib stress fuse-exfat exfat-utils "
#IMAGE_INSTALL += " ppp ntp e2fsprogs cronie e2fsprogs-e2fsck e2fsprogs-resize2fs inetutils inetutils-telnet inetutils-telnetd "
#IMAGE_INSTALL += " packagegroup-core-eclipse-debug "

# Native Compiler
IMAGE_INSTALL +=" add-router wifi-modprobe add-led-ctrl desktop-dhcp "
# desktop-dhcp

# Tools 
APTGET_EXTRA_PACKAGES += " \
    tcpdump \
    iperf3 \
    fonts-wqy-zenhei \
    xfonts-intl-chinese \
    xfonts-wqy \
    fonts-wqy-microhei \
    libpcap0.8 \
    ppp \
    usb-modeswitch \
    mobile-broadband-provider-info \
    modemmanager \
    kpartx \
    pciutils \
    usbutils \
    blueman \
    network-manager \
    network-manager-gnome \
    network-manager-l2tp \
    network-manager-openvpn \
    network-manager-pptp \
    network-manager-strongswan \
    network-manager-vpnc \
    can-utils \
    i2c-tools \
    iptables \
    nftables \
    isc-dhcp-server \
"
