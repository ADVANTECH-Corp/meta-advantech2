#!/bin/bash
CURRENT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
echo $CURRENT_DIR

video_node1=
video_node2=

check_usb_camera_node()
{
	v4l2-ctl --list-device > $CURRENT_DIR/usb_camera_node.log

	video_node1=`cat $CURRENT_DIR/usb_camera_node.log | grep USB -A 1 | grep /dev/video | awk {'print $1'} | awk NR==1`
	video_node2=`cat $CURRENT_DIR/usb_camera_node.log | grep USB -A 1 | grep /dev/video | awk {'print $1'} | awk NR==2`

	echo "video_node1=$video_node1 , video_node2=$video_node2"
	if [ -z "$video_node1" ] || [ -z "$video_node2" ]
	then
		echo "Not Find USB Camera Node,Check Status Of Cabel Connnection"
		echo "Must Insert Two USB Cameras"
		exit 0
	else
		rm $CURRENT_DIR/usb_camera_node.log
	fi
}

Adapt_correct_usb_camera_node()
{
	cut_video_node2=`echo $video_node2 | cut -f 3 -d / | sed 's/video//'`
	echo cut_video_node2=$cut_video_node2

	sed -i 's/device=\/dev\/video[0-9]*/device=\/dev\/video'${cut_video_node2}'/g' $CURRENT_DIR/multi_stream_detection_test_up_down.sh

	cat $CURRENT_DIR/multi_stream_detection_test_up_down.sh | grep "device=/dev/" | cut -f 1 -d !
}
###########
# main()
###########
check_usb_camera_node
Adapt_correct_usb_camera_node

echo ""
echo "Start usb camera demo"
$CURRENT_DIR/multi_stream_detection_test_up_down.sh --set-live-source $video_node1
