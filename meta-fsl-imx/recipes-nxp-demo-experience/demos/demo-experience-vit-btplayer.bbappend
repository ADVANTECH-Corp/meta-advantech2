SRC_URI = "\
        ${NXPAFE_VOICESEEKER_SRC};branch=${SRCBRANCH_voice};name=voice \
        ${NXP_DEMO_ASSET_SRC};branch=${SRCBRANCH_model};name=model;subpath=build/demo-experience-voice-demo-bt-player \
        ${NXP_BTPLAYER_SRC};branch=${SRCBRANCH_player};name=player;subpath=voiceAction \
        file://0001-Change-Recipe-Target-Sysroot-path.patch \
	file://0001-changed-BUILD_ARCH-CortexA55.patch      \
        "

# SRC_URI:append:imx93-11x11-lpddr4x-evk = " file://0001-changed-BUILD_ARCH-CortexA55.patch "
