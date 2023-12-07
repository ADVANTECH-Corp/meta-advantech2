#!/bin/sh

while true
do
    gst-launch-1.0  filesrc location=/tools/4k.mp4 ! decodebin ! imxvideoconvert_g2d ! autovideosink #glimagesink
    sleep 1
done
