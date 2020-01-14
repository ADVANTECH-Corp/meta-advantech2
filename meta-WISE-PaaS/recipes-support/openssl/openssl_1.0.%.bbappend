# Backward compatible to Yocto 2.1 toolchain
do_install_append_class-target () {
    ln -sf libcrypto${SOLIBS} ${D}${libdir}/libcrypto.so.1.0.0
    ln -sf libssl${SOLIBS} ${D}${libdir}/libssl.so.1.0.0
}

FILES_libcrypto += " ${libdir}/libcrypto.so.1.0.0"
FILES_libssl += " ${libdir}/libssl.so.1.0.0"
