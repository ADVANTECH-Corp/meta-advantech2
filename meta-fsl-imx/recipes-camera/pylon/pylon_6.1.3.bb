LICENSE = "pylon & LGPL-3.0-only & LGPL-2.1-only & BSD-3-Clause & BSD-2-Clause & bzip2 & Libpng & Zlib & GenICam-1.1 & NI & xxHash & Apache-2.0"
LIC_FILES_CHKSUM = "file://share/pylon/licenses/License.html;md5=b966523debb4b5dc8429530d00d2e8be \
                    file://share/pylon/licenses/pylon_Third-Party_Licenses.html;md5=d44d1888d27af3c99b4d1b7a4d94ea8b"

PROVIDES = "pylon"
RPROVIDES:${PN} = "pylon"

PR = "r0"
PYLON_VERSION = "_6.1.3.20159_aarch64"

require recipes-camera/pylon/pylon.inc

SRC_URI = "file://${PYLON_TAR_FILENAME};subdir=${S}"

do_install() {
    # Copy the contents of the source folder (pylon6 folder) to opt folder
    install -d "${D}/opt/pylon6"
    cp -dR --preserve=mode,links,timestamps --no-preserve=ownership "${S}"/* "${D}/opt/pylon6/"

    # Create a script file which sets automatically the GENICAM_GENTL64_PATH env variable before it starts the pylon viewer.
    install -d "${D}/usr/bin"
    echo '#!/bin/sh' >"${D}"/usr/bin/pylon
    echo 'GENICAM_GENTL64_PATH=/opt/dart-bcon-mipi/lib exec /opt/pylon6/bin/pylonviewer "${@}"' >>"${D}"/usr/bin/pylon
    chmod 755 "${D}"/usr/bin/pylon
}

