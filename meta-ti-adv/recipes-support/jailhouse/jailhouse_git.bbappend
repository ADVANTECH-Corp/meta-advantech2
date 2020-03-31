
COMPATIBLE_MACHINE = "am57xx-evm|am57xxrom7510a1"

JAILHOUSE_EXAMPLE_FILES_append_am57xxrom7510a1 = " \
    configs/am57xx-pdk-leddiag.cell \
    configs/am572x-rtos-icss.cell \
    configs/am572x-rtos-pruss.cell \
"

do_configure_prepend_am57xxrom7510a1() {
    cp ./ci/jailhouse-config-am57xx-evm.h ./ci/jailhouse-config-${MACHINE}.h
}

do_install_prepend_am57xxrom7510a1() {
    cp ./configs/am57xx-evm.cell ./configs/${MACHINE}.cell
    cp ./configs/am57xx-evm-ti-app.cell ./configs/${MACHINE}-ti-app.cell
}


