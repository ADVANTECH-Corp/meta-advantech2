DESCRIPTION = "Yocto core image with Advantech EdgeSense feature"

require ota.inc

IMAGE_INSTALL += " fsl-rc-local e2fsprogs-resize2fs "

#RMM & SUSI_4.0
IMAGE_INSTALL += "\
   sqlite3 lua uci \
   curl curl-dev libxml2 libxml2-dev openssl openssl-dev lsb \
   mosquitto mosquitto-dev libdmclient libdmclient-dev "

