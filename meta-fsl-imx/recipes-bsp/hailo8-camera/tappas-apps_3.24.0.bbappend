SUMMARY = "ADV hailo8-camera demo"
FILESEXTRAPATHS_prepend := "${THISDIR}/files:"
SRC_URI += "file://2-4_cam_detection_facial_landmark.sh \
	    file://1-2_cam_detection_facial_landmark.sh \
	    file://lightface_slim.hef \
	    file://tddfa_mobilenet_v1.hef \
	    file://yolov5s_nv12.hef \
	    file://yolov5.json \
	    file://multi_stream_detection_test_up_down.sh \
	    file://double_usb_camera_demo.sh \
	    file://README.rst \
	    file://yolov5m_yuv.hef \
"


do_install_append() {
	install -d ${D}/home/root/apps/advantech_0529
	install -m 0755 ${WORKDIR}/2-4_cam_detection_facial_landmark.sh ${D}/home/root/apps/advantech_0529/2-4_cam_detection_facial_landmark.sh
	install -m 0755 ${WORKDIR}/1-2_cam_detection_facial_landmark.sh ${D}/home/root/apps/advantech_0529/1-2_cam_detection_facial_landmark.sh

	install -d ${D}/home/root/apps/advantech_0529/resources
	install -m 0755 ${WORKDIR}/lightface_slim.hef ${D}/home/root/apps/advantech_0529/resources/lightface_slim.hef
	install -m 0755 ${WORKDIR}/tddfa_mobilenet_v1.hef ${D}/home/root/apps/advantech_0529/resources/tddfa_mobilenet_v1.hef
	install -m 0755 ${WORKDIR}/yolov5s_nv12.hef ${D}/home/root/apps/advantech_0529/resources/yolov5s_nv12.hef

	install -d ${D}/home/root/apps/advantech_0529/resources/configs
	install -m 0755 ${WORKDIR}/yolov5.json ${D}/home/root/apps/advantech_0529/resources/configs/yolov5.json

	install -d ${D}/home/root/apps/double_usb_camra_detection
	install -m 0755 ${WORKDIR}/multi_stream_detection_test_up_down.sh ${D}/home/root/apps/double_usb_camra_detection/multi_stream_detection_test_up_down.sh
	install -m 0755 ${WORKDIR}/double_usb_camera_demo.sh ${D}/home/root/apps/double_usb_camra_detection/double_usb_camera_demo.sh
	install -m 0755 ${WORKDIR}/README.rst ${D}/home/root/apps/double_usb_camra_detection/README.rst

	install -d ${D}/home/root/apps/double_usb_camra_detection/resources
	install -m 0755 ${WORKDIR}/yolov5m_yuv.hef ${D}/home/root/apps/double_usb_camra_detection/resources/yolov5m_yuv.hef

	install -d ${D}/home/root/apps/double_usb_camra_detection/resources/configs
	install -m 0755 ${WORKDIR}/yolov5.json ${D}/home/root/apps/double_usb_camra_detection/resources/configs/yolov5.json
}

FILES_${PN} += " /home/root/apps/advantech_0529 /home/root/apps/double_usb_camra_detection "
