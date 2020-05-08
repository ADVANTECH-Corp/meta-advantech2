
MULTIMEDIA_remove_omap-a15 = " \
    dual-camera-demo \
    image-gallery \
    hevc-arm-decoder \
    ${@bb.utils.contains('MACHINE_FEATURES', 'dsp', 'qt-opencv-opencl-opengl-multithreaded-dev', '', d)} \
"

