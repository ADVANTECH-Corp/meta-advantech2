SUMMARY = "ADV hailo8-camera demo"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://2or4_cam_detection_facial_landmark_independence.sh \
	    file://1or2_cam_detection_facial_landmark_both.sh \
	    file://lightface_slim.hef \
	    file://tddfa_mobilenet_v1.hef \
	    file://yolov5s_nv12.hef \
	    file://yolov5.json \
	    file://multi_stream_detection_test_up_down.sh \
	    file://double_usb_camera_demo.sh \
	    file://README.rst \
	    file://yolov5m_yuv.hef \
	    file://hailo_IP_camera_demo.service \
	    file://hailo_IP_camera_demo.sh \
	    file://hailo_USB_camera_demo.service \
	    file://hailo_USB_camera_demo.sh \
"


do_install_append() {
	install -d ${D}/home/root/apps/ip_camera_demo
	install -m 0755 ${WORKDIR}/2or4_cam_detection_facial_landmark_independence.sh ${D}/home/root/apps/ip_camera_demo/2or4_cam_detection_facial_landmark_independence.sh
	install -m 0755 ${WORKDIR}/1or2_cam_detection_facial_landmark_both.sh ${D}/home/root/apps/ip_camera_demo/1or2_cam_detection_facial_landmark_both.sh

	install -d ${D}/home/root/apps/ip_camera_demo/resources
	install -m 0755 ${WORKDIR}/lightface_slim.hef ${D}/home/root/apps/ip_camera_demo/resources/lightface_slim.hef
	install -m 0755 ${WORKDIR}/tddfa_mobilenet_v1.hef ${D}/home/root/apps/ip_camera_demo/resources/tddfa_mobilenet_v1.hef
	install -m 0755 ${WORKDIR}/yolov5s_nv12.hef ${D}/home/root/apps/ip_camera_demo/resources/yolov5s_nv12.hef

	install -d ${D}/home/root/apps/ip_camera_demo/resources/configs
	install -m 0755 ${WORKDIR}/yolov5.json ${D}/home/root/apps/ip_camera_demo/resources/configs/yolov5.json

	install -d ${D}/home/root/apps/double_usb_camra_detection
	install -m 0755 ${WORKDIR}/multi_stream_detection_test_up_down.sh ${D}/home/root/apps/double_usb_camra_detection/multi_stream_detection_test_up_down.sh
	install -m 0755 ${WORKDIR}/double_usb_camera_demo.sh ${D}/home/root/apps/double_usb_camra_detection/double_usb_camera_demo.sh
	install -m 0755 ${WORKDIR}/README.rst ${D}/home/root/apps/double_usb_camra_detection/README.rst

	install -d ${D}/home/root/apps/double_usb_camra_detection/resources
	install -m 0755 ${WORKDIR}/yolov5m_yuv.hef ${D}/home/root/apps/double_usb_camra_detection/resources/yolov5m_yuv.hef

	install -d ${D}/home/root/apps/double_usb_camra_detection/resources/configs
	install -m 0755 ${WORKDIR}/yolov5.json ${D}/home/root/apps/double_usb_camra_detection/resources/configs/yolov5.json

	install -d ${D}/lib/systemd/system
	install -m 0755 ${WORKDIR}/hailo_IP_camera_demo.service ${D}/lib/systemd/system/hailo_IP_camera_demo.service
	install -m 0755 ${WORKDIR}/hailo_USB_camera_demo.service ${D}/lib/systemd/system/hailo_USB_camera_demo.service

	install -d ${D}/tools
	install -m 0755 ${WORKDIR}/hailo_IP_camera_demo.sh ${D}/tools/hailo_IP_camera_demo.sh
	install -m 0755 ${WORKDIR}/hailo_USB_camera_demo.sh ${D}/tools/hailo_USB_camera_demo.sh
}

FILES_${PN} += " /home/root/apps/ip_camera_demo /home/root/apps/double_usb_camra_detection /lib/systemd/system /tools "
