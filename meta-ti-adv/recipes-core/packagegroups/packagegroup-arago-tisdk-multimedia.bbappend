
ACCEL_FW_append_am57xxrom7510a1 = " \
    ${@bb.utils.contains('MACHINE_FEATURES', 'mmip', 'ipumm-fw', '', d)} \
"

