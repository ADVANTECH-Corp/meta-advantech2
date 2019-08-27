FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"


SRC_URI_append = " \
	file://0001-Names-are-case-insensitive.patch \
"

