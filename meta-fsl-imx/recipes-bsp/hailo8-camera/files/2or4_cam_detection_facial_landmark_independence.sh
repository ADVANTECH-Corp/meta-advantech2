#!/bin/bash

# base on multistream_detection/multi_stream_detection_stream_multiplexer.sh
set -e

CURRENT_DIR="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"
function init_variables() {
    print_help_if_needed $@
    script_dir=$(dirname $(realpath "$0"))
    #source $script_dir/../../../../../scripts/misc/checks_before_run.sh

    # Webcam/RTSP for Detection
    readonly DETECTION_INPUT0="rtsp://admin:Advantech@192.168.1.107:554/cam/realmonitor?channel=1\&subtype=1"
    readonly DETECTION_INPUT1="rtsp://admin:Advantech@192.168.1.108:554/cam/realmonitor?channel=1\&subtype=1"

    # Webcam/RTSP for Facial Landmark
    readonly FACIAL_LANDMARK_INPUT0="rtsp://admin:Advantech@192.168.1.109:554/cam/realmonitor?channel=1\&subtype=1"
    readonly FACIAL_LANDMARK_INPUT1="rtsp://admin:Advantech@192.168.1.110:554/cam/realmonitor?channel=1\&subtype=1"

    readonly RESOURCES_DIR="${CURRENT_DIR}/resources"
    readonly POSTPROCESS_DIR="/usr/lib/hailo-post-processes"
    
    #readonly POSTPROCESS_SO="$POSTPROCESS_DIR/libyolo_post.so"
    readonly DETECTION_POSTPROCESS_SO="$POSTPROCESS_DIR/libyolo_post.so"
    readonly FACE_DETECTION_POSTPROCESS_SO="$POSTPROCESS_DIR/libface_detection_post.so"
    readonly CROPPER_POSTPROCESS_SO="$POSTPROCESS_DIR/cropping_algorithms/lib3ddfa.so"
    readonly FACIAL_LANDMARK_POSTPROCESS_SO="$POSTPROCESS_DIR/libfacial_landmarks_post.so"

    readonly DETECTION_HEF_PATH="$RESOURCES_DIR/yolov5s_nv12.hef"
    readonly FACE_DETECTION_HEF_PATH="$RESOURCES_DIR/lightface_slim.hef"
    readonly FACIAL_LANDMARK_HEF_PATH="$RESOURCES_DIR/tddfa_mobilenet_v1.hef"

    readonly DETECTION_JSON_CONFIG_PATH="$RESOURCES_DIR/configs/yolov5.json" 


    num_of_src=1
    additional_parameters=""
    detection_sources=""
    facial_landmark_sources=""
    compositor_locations2="sink_0::xpos=0 sink_0::ypos=40 sink_1::xpos=700 sink_1::ypos=0"
    compositor_locations4="sink_0::xpos=0 sink_0::ypos=40 sink_1::xpos=700 sink_1::ypos=0 \
                            sink_2::xpos=0 sink_2::ypos=680 sink_3::xpos=700 sink_3::ypos=640"
    
    #compositor_locations="sink_0::xpos=0 sink_0::ypos=40 sink_1::xpos=640 sink_1::ypos=0 sink_2::xpos=1280 sink_2::ypos=0 sink_3::xpos=1920 sink_3::ypos=0 sink_4::xpos=0 sink_4::ypos=640 sink_5::xpos=640 sink_5::ypos=640 sink_6::xpos=1280 sink_6::ypos=640 sink_7::xpos=1920 sink_7::ypos=640 sink_8::xpos=0 sink_8::ypos=1280 sink_9::xpos=640 sink_9::ypos=1280 sink_10::xpos=1280 sink_10::ypos=1280 sink_11::xpos=1920 sink_11::ypos=1280 sink_12::xpos=0 sink_12::ypos=1920 sink_13::xpos=640 sink_13::ypos=1920 sink_14::xpos=1280 sink_14::ypos=1920 sink_15::xpos=1920 sink_15::ypos=1920"
    compositor_locations="sink_0::xpos=0 sink_0::ypos=40 sink_1::xpos=700 sink_1::ypos=0"
    print_gst_launch_only=false
    video_sink_element="autovideosink"
    detection_json_config_path=$DETECTION_JSON_CONFIG_PATH
    width=640
    height=720
    internal_offset=false
}

function print_usage() {
    echo "Multistream Detection hailo - pipeline usage:"
    echo ""
    echo "Options:"
    echo "  --help                          Show this help"
    echo "  --show-fps                      Printing fps"
    echo "  --num-of-sources NUM            Setting number of sources to given input for each app pipeline (default value is 1, maximum value is 2)"
    echo "  --print-gst-launch              Print the ready gst-launch command without running it"
    exit 0
}

function print_help_if_needed() {
    while test $# -gt 0; do
        if [ "$1" = "--help" ] || [ "$1" == "-h" ]; then
            print_usage
        fi

        shift
    done
}

function parse_args() {
    while test $# -gt 0; do
        if [ "$1" = "--help" ] || [ "$1" == "-h" ]; then
            print_usage
            exit 0
        elif [ "$1" = "--print-gst-launch" ]; then
            print_gst_launch_only=true
        elif [ "$1" = "--show-fps" ]; then
            echo "Printing fps"
            additional_parameters="-v 2>&1 | grep hailo_display"
        elif [ "$1" = "--num-of-sources" ]; then
            shift
            echo "Setting number of sources to $1"
            num_of_src=$1
            if [ $1 = 1 ]; then
                compositor_locations=$compositor_locations2
            elif [ $1 = 2 ]; then
                compositor_locations=$compositor_locations4
            else
                echo "Maximum number of sources is 2"
                 print_usage
                 exit 1
            fi
        else
            echo "Received invalid argument: $1. See expected arguments below:"
            print_usage
            exit 1
        fi
        shift
    done
}

function create_sources() {
    for ((m = 0; m < $num_of_src; m++)); do
        detection_inputn="DETECTION_INPUT${m}"
        facial_landmark_inputn="FACIAL_LANDMARK_INPUT${m}"

        n=$(( m*2 ))
        if [[ ${!detection_inputn} =~ "/dev/video" ]]; then
            detection_sources+="v4l2src device=${!detection_inputn} name=src_$n ! videoflip video-direction=horiz !"
        else
            detection_sources+="rtspsrc location=${!detection_inputn} name=src_$n message-forward=true ! \
                queue leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! decodebin ! video/x-raw, format=NV12 ! videoscale qos=false ! \
                video/x-raw, pixel-aspect-ratio=1/1 !"
        fi
       
        detection_sources+="queue name=hailo_preprocess_q_$n leaky=no max-size-buffers=5 max-size-bytes=0  \
                max-size-time=0 ! videoconvert qos=false ! \
                queue name=hailo_pre_infer_q_$n leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
                hailonet hef-path=$DETECTION_HEF_PATH scheduling-algorithm=1 batch-size=1 vdevice-key=1 ! \
                queue name=hailo_postprocess0_$n leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
                hailofilter so-path=$DETECTION_POSTPROCESS_SO config-path=$detection_json_config_path qos=false ! \
                queue name=hailo_draw0_$n leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
                hailooverlay ! \
                queue name=comp_q_$n leaky=downstream max-size-buffers=5 \
                max-size-bytes=0 max-size-time=0 ! comp.sink_$n "
        
        n=$(( m*2 + 1))
        if [[ ${!facial_landmark_inputn} =~ "/dev/video" ]]; then
            facial_landmark_sources+="v4l2src device=${!facial_landmark_inputn} name=src_$n ! video/x-raw, format=YUY2, width=$width, height=$height ! "
            internal_offset=false
        else
            facial_landmark_sources+="rtspsrc location=${!facial_landmark_inputn} name=src_$n message-forward=true ! \
                queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! decodebin ! queue ! decodebin ! \
                video/x-raw, format=NV12 ! videoscale ! video/x-raw,pixel-aspect-ratio=1/1, width=$width, height=$height !"
            internal_offset=true
        fi
       
        facial_landmark_sources+="queue name=hailo_preprocess_q_$n leaky=no max-size-buffers=10 max-size-bytes=0  \
                max-size-time=0 ! videoconvert qos=false !  \
                tee name=t_$n hailomuxer name=hmux_$n t_$n. ! queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
                hmux_$n. t_$n. ! videoscale qos=false ! queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
                hailonet hef-path=$FACE_DETECTION_HEF_PATH scheduling-algorithm=1 scheduler-threshold=5 scheduler-timeout-ms=100 vdevice-key=1 ! \
                queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
                hailofilter so-path=$FACE_DETECTION_POSTPROCESS_SO function-name=lightface qos=false ! \
                queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! hmux_$n. hmux_$n. ! \
                queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
                hailocropper so-path=$CROPPER_POSTPROCESS_SO function-name=create_crops internal-offset=$internal_offset name=cropper_$n \
                hailoaggregator name=agg_$n cropper_$n. ! queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
                agg_$n. cropper_$n. ! queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
                hailonet hef-path=$FACIAL_LANDMARK_HEF_PATH \
                scheduling-algorithm=1 scheduler-threshold=5 scheduler-timeout-ms=100 vdevice-key=1 ! \
                queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! \
                hailofilter function-name=facial_landmarks_merged so-path=$FACIAL_LANDMARK_POSTPROCESS_SO qos=false ! \
                queue leaky=no max-size-buffers=30 max-size-bytes=0 max-size-time=0 ! agg_$n. agg_$n. ! \
                queue leaky=no max-size-buffers=10 max-size-bytes=0 max-size-time=0 ! \
                hailooverlay qos=false ! \
                queue name=comp_q_$n leaky=downstream max-size-buffers=10 \
                max-size-bytes=0 max-size-time=0 ! comp.sink_$n "
    done
}

function main() {
    init_variables $@
    parse_args $@

    create_sources

    pipeline="gst-launch-1.0 \
           compositor name=comp start-time-selection=0 $compositor_locations ! \
           queue name=hailo_video_q_0 leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
           videoconvert ! queue name=hailo_display_q_0 leaky=no max-size-buffers=5 max-size-bytes=0 max-size-time=0 ! \
           fpsdisplaysink video-sink=$video_sink_element name=hailo_display sync=false text-overlay=false \
           $detection_sources $facial_landmark_sources ${additional_parameters}"

    echo ${pipeline}
    if [ "$print_gst_launch_only" = true ]; then
        exit 0
    fi

    echo "Running Pipeline..."
    eval "${pipeline}"

}

main $@
