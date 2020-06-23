
IMAGE_INSTALL += "\
   linux-firmware-bcm43241b4 "

IMAGE_INSTALL += "\
   ppp"

# Wise-PaaS
IMAGE_INSTALL += "\
   susi4 susi-iot"

# timezone
IMAGE_INSTALL += "\
   tzdata"

# minicom
IMAGE_INSTALL += "\
   minicom"

IMAGE_INSTALL += "\
   cmake \
   mosquitto-clients mosquitto mosquitto-dev \
   libxml2 libxml2-dev \
   git-perltools \
   openobex obexd \
   openobex-dev \
   python-pybluez \
   "
TOOLCHAIN_TARGET_TASK += "\
   cmake \
   git git-perltools \
   curl curl-dev \
   mosquitto-clients mosquitto mosquitto-dev \
   libxml2 libxml2-dev \
   linux-libc-headers-dev \
   openobex obexd \
   glibc-staticdev \
"

INHERIT += "own-mirrors"
SOURCE_MIRROR_URL = "http://software-dl.ti.com/processor-sdk-mirror/sources/"


