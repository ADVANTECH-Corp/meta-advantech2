FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += "file://add_weston_exception_handle.patch \
	    file://autorun_keyevent_and_ec_uevent.patch"
