
do_image_wic_append_am62xx-rs10[depends] += " wifi-oob:do_deploy"
IMAGE_BOOT_FILES_append_am62xx-rs10 += " wificfg"

#Advantech package
require ti-image-adv.inc
