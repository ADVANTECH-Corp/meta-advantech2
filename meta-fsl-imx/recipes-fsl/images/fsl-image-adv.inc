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
IMAGE_INSTALL += " enable485 add-virtual-network advresize-script boottimes-script st \
		   quectel-script 3g-script stress-script xterm mdio-tool hwclock \
		   poweronoff-script "
IMAGE_INSTALL_append_imx8mpepcr5710a1 = " ecsd "
IMAGE_INSTALL_append_imx8mmrsb3730a2 = " ecsd "


# Depends on projects
IMAGE_INSTALL_append = " tcpdump "
IMAGE_INSTALL_append = " iperf3 bridge-utils "
IMAGE_INSTALL_append_imx6qrom5420a1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6qrom5420b1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6dlrom5420b1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6qrom3420a1 = " keyevent"
IMAGE_INSTALL_append_imx6qrom7420a1 = " keyevent"
IMAGE_INSTALL_append_imx6qprom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6qrom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6dlrom7421a1 = " ecuevent keyevent"
IMAGE_INSTALL_append_imx6qrsb4410a1 = " lirc "
IMAGE_INSTALL_append_imx6qrsb4410a2 = " lirc "
IMAGE_INSTALL_append_mx8 = " si-script keyevent "
IMAGE_INSTALL_append_imx8qmrom7720a1 = " wdt-button "
IMAGE_INSTALL_append_imx8mprsb3720a1 = " xauth \
                                   pylon \
                                   python3-pypylon \
                                   gentl-producer \
                                   "
IMAGE_INSTALL_append_imx8mpepcr5710a1 = " xauth \
                                   pylon \
                                   python3-pypylon \
                                   gentl-producer \
                                   add-router \
                                   dhcp-server \
								   libhailort \
								   hailortcli \
								   pyhailort \
								   libgsthailo \
								   hailo-pci \
								   hailo-firmware \
								   libgsthailotools \
								   tappas-apps \
								   add-led-ctrl \
								   hailo-post-processes \
								   apphub-edge \
								   chromium-ozone-wayland \
								   ttf-wqy-zenhei \
								   adv-dhcp \
								   "
#docker-ce 

IMAGE_INSTALL_remove_imx8mpepcr5710a1 = " add-virtual-network "
IMAGE_INSTALL_remove_imx8mmrsb3730a2 = " add-virtual-network "

# Browser
#IMAGE_INSTALL += " firefox "
