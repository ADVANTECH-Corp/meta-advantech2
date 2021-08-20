SUMMARY = "Shell scripts to enable audio mixer for playback & recording"
LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-or-later;md5=fed54355545ffd980b814dab4a3b312c"

SRC_URI = "file://audio_playback.sh \
	   file://audio_recording.sh"

do_install() {
    install -d ${D}/tools
    install -m 755 ${WORKDIR}/audio_playback.sh ${D}/tools/audio_playback.sh
    install -m 755 ${WORKDIR}/audio_recording.sh ${D}/tools/audio_recording.sh
}

FILES_${PN} = "/tools"
