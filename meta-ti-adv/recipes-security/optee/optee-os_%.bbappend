
EXTRA_OEMAKE_append_am62xx-rs10 = " CFG_WITH_SOFTWARE_PRNG=y CFG_TEE_CORE_LOG_LEVEL=1"

do_compile_append_am62xx-rs10() {
    optee_sign_k3hs
}
