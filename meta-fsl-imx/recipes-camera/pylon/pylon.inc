SUMMARY = "Basler pylon Camera Software Suite"
DESCRIPTION = "A software package comprised of an easy-to-use SDK and tools that you can use to operate any Basler camera."

RDEPENDS_${PN} = "fontconfig freetype libsm libdrm libxcb-glx"

FILES_${PN} += "/opt/ /usr/bin/pylon"

INSANE_SKIP_${PN} += "already-stripped"
INSANE_SKIP_${PN} += "dev-so"
INSANE_SKIP_${PN} += "dev-elf"

# Work around for RDEPENDS to avoid 'no libGL.so.1()(64bit) provider found' problem
SKIP_FILEDEPS_${PN} = "1"

# Without this option yocto checks every .so included in pylon and treats it as possible RPROVIDES.
# This lead to spurious dependencies of gstreamer packages on pylon.
EXCLUDE_FROM_SHLIBS = "1"

# We want the complete pylon inside the sysroot to be able to build against it
SYSROOT_DIRS = "/opt"

PACKAGES_${PN} = "${PN}"

PYLON_TAR_FILENAME = "pylon${PYLON_VERSION}.tar.gz"
