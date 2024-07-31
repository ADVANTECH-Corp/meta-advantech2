# Advantech package
IMAGE_FEATURES += " ssh-server-openssh "

IMAGE_INSTALL += " poweronoff-script boottimes-script "

IMAGE_INSTALL:append = " bluez5 bluez5-noinst-tools bluez5-obex openobex obexftp glibc-gconv-utf-16 glibc-utils libusb1"

IMAGE_INSTALL:append:imx8mmebcrs12a1 = " ecsd  adv-overlay "
