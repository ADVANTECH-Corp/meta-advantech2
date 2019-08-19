
IMAGE_INSTALL += "\
   linux-firmware-bcm43241b4 "

IMAGE_INSTALL += "\
   ppp"


IMAGE_INSTALL += "\
   mosquitto mosquitto-dev \
   libxml2 libxml2-dev \
   git-perltools \
   openobex obexd \
   openobex-dev \
   python-pybluez \
   minicom \
   "
TOOLCHAIN_TARGET_TASK += "\
   curl curl-dev \
   mosquitto mosquitto-dev \
   libxml2 libxml2-dev \
   linux-libc-headers-dev \
   openobex obexd \
   glibc-staticdev \
"

