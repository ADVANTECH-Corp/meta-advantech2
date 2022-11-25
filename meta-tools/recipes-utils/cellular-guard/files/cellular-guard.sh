#!/usr/bin/env bash
#
# Created on Fri Sep 23 2022
#
# Copyright (C) 1983-2022 Advantech Co., Ltd.
# Author: Hong.Guo, hong.guo@advantech.com.cn
#

# a script to monitor modem state
#

set -o pipefail

#  ---------- global variables begin ------------

# constants variables
STATUS_CONFIG_PATH=/data/status.conf

# Used for delay time of "main program module" loop, default:8h
CHECK_INTERVAL=${CHECK_INTERVAL:-8h}

# Used for delay time of "frequency maintenance module" check network, default:1h
PING_INTERVAL=${PING_INTERVAL:-1h}

# Used for Record the number of network check failures in "frequency maintenance module", default:12
MAX_PING_ERROR_COUNT=${MAX_PING_ERROR_COUNT:-12}

# Minimum value of 4G module frequency clearing of "frequency maintenance module", default:2
MAX_FREQUENCY_ERROR_COUNT_MIN=${MAX_FREQUENCY_ERROR_COUNT_MIN:-2}

# Max value of 4G module frequency clearing of "frequency maintenance module", default:5
MAX_FREQUENCY_ERROR_COUNT_MAX=${MAX_FREQUENCY_ERROR_COUNT_MAX:-5}

# Used for trigger 4G module frequency clearing of "SIM card maintenance module", default:3
MAX_SIM_ERROR_COUNT=${MAX_SIM_ERROR_COUNT:-3}

# corrent num of modem manager
MODEM_INDEX=0
# count of 4G frequency clearing of "frequency maintenance module"
CURRENT_MAX_FREQUENCY_ERROR_COUNT=${MAX_FREQUENCY_ERROR_COUNT_MIN}

# from parameters
JUMP=
SOURCE_MODE=n
DEBUG=
#  ---------- global variables end ------------

if [ -f $STATUS_CONFIG_PATH ]; then
    # shellcheck disable=SC1090
    # will restore CURRENT_HARD_RESET_COUNT
    source $STATUS_CONFIG_PATH
else
    mkdir -p "$(dirname $STATUS_CONFIG_PATH)"
fi

debug() {
    if [ "$DEBUG" = '0' ]; then
        echo "$*"
    fi
}

# hardware reset 4G module
hard_reset() {
    # Valid time: 150ms -- 460 ms, If it is greater than 460ms, the module will enter the second reset
    gpio 1 0
    # sleep 200ms
    sleep 0.2
    gpio 1 1
    sleep 5
}

# Call dbus restart a systemd service
# Reference: https://dbus.freedesktop.org/doc/dbus-send.1.html
# https://www.balena.io/docs/learn/develop/runtime/#d-bus-communication-with-host-os
restart_service() {
    local service_name="$1"
    if ! [[ $service_name =~ \.service$ ]]; then
        service_name="$service_name.service"
    fi
    dbus-send --print-reply --type=method_call --system --dest=org.freedesktop.systemd1 \
        /org/freedesktop/systemd1 org.freedesktop.systemd1.Manager.RestartUnit \
        string:"$service_name" string:"replace" || {
        return 1
    }
}

restart_ModemManager() {
    restart_service ModemManager
    # wait for service restart
    sleep 5
}

restart_NetworkManager() {
    restart_service NetworkManager
    # wait for service restart
    sleep 5
}

get_modem_index() {
    local result
    while true; do
        result=$(
            dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.ModemManager1 \
                /org/freedesktop/ModemManager1 org.freedesktop.DBus.ObjectManager.GetManagedObjects |
                grep -Eo '/org/freedesktop/ModemManager1/Modem/[0-9]+' |
                sed -En 's|/org/freedesktop/ModemManager1/Modem/([0-9]+)|\1|p' | head -1
        )
        # retry if modem manager is not start or modem is not ready
        if [ $? -ne 0 ] || [ -z "$result" ]; then
            sleep 5
        else
            if [ "$MODEM_INDEX" != "$result" ]; then
                echo "modem index changed to $result"
                MODEM_INDEX="$result"
            fi
            return 0
        fi
    done
}

# Send AT command to modem and output result
# Return 0 if send successfully
# Timeout is (probably) 2 seconds
# Also see https://www.freedesktop.org/software/ModemManager/api/latest/gdbus-org.freedesktop.ModemManager1.Modem.html#gdbus-method-org-freedesktop-ModemManager1-Modem.Command
AT_send() {
    local at_command="$1"
    local result

    get_modem_index

    # use ModemManager Api not echo to /dev/ttyUSB2 directly to avoid device occupancy conflicts

    # dbus-send:
    # if send: AT+QENG="SERVINGCELL"
    # output:  +QENG: "servingcell","NOCONN","LTE","FDD",262,01,25A5507,212,500,1,5,5,67BD,-93,-7,-65,15,28
    result=$(
        dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.ModemManager1 \
            /org/freedesktop/ModemManager1/Modem/"$MODEM_INDEX" org.freedesktop.ModemManager1.Modem.Command \
            string:"$at_command" uint32:2000 | sed -e 's|^[[:space:]]*||'
    )

    if [ $? -ne 0 ]; then
        return 1
    fi

    # will return like: "servingcell","NOCONN","LTE","FDD",262,01,25A5507,212,500,1,5,5,67BD,-93,-7,-65,15,28
    cut -d: -f2- <<<"$result" | sed -e 's|^[[:space:]]*||'
}

# AT+QMBNCFG="AutoSel"
# MBNCFG="AutoSel",1
check_mbn() {
    local result
    if ! result=$(AT_send 'AT+QMBNCFG="AutoSel"'); then
        return 1
    fi
    debug "AT+QMBNCFG=\"AutoSel\" result:$result"
    echo "$result" | grep -Eq '1$'
}

# AT+QMBNCFG="AutoSel",1
set_mbn() {
    AT_send 'AT+QMBNCFG="AutoSel",1' &>/dev/null
}

# AT+CPIN?
# READY found
# sim card
check_sim_status() {
    local result

    if ! result=$(AT_send 'AT+CPIN?'); then
        return 2
    fi
    debug "AT+CPIN? result:$result"

    # ERROR: 13: sim error
    # ERROR: 10: no sim
    if echo "$result" | grep -Eq 'ERROR: 10'; then
        return 10
    fi

    echo "$result" | grep -q 'READY'
}

# AT+CCID
check_sim_ccid() {
    local result

    if ! result=$(AT_send 'AT+CCID'); then
        return 2
    fi
    debug "AT+CCID result:$result"

    # ERROR: 13: sim error

    if ! echo "$result" | grep -Eq '^[0-9]+$'; then
        return 1
    fi
}

# Network resident of 4G module
check_registration() {
    local result
    # this will return empty string if no error
    # see https://github.com/freedesktop/ModemManager/blob/eae2e28577c53e8deaa25d46d6032d5132be6b58/src/mm-modem-helpers.c#L818
    if ! result=$(AT_send 'AT+CEREG?'); then
        return 2
    fi
    debug "AT+CEREG? result:$result, it's normal if is empty."

    # not empty return 1
    [ -z "$result" ] || return 1

    # result like: "servingcell","NOCONN","LTE","FDD",262,01,25A5507,212,500,1,5,5,67BD,-93,-7,-65,15,28
    if ! result=$(AT_send 'AT+QENG="servingcell"'); then
        return 2
    fi

    debug "AT+QENG=\"servingcell\" result:$result"

    # SEARCH, LIMSRV, NOCONN, CONNECT
    if ! echo "$result" | grep -q 'NOCONN'; then
        return 1
    fi
}

# AT command restart 4G module
restart_module() {
    AT_send 'AT+CFUN=1,1' &>/dev/null
    # wait for modem restart
    sleep 5
}

# frequency clearing
frequency_clear() {
    # clear 4G frequency
    AT_send 'AT+QNVFD="/nv/reg_files/modem/lte/rrc/csp/acq_db"' &>/dev/null
    # clear 2G frequency
    AT_send 'AT+QCFG="nwoptmz/acq",0' &>/dev/null
}

# check nerwork，timeout 5s
ping_network() {
    # ping return 0 if success
    # return 1 if packet loose
    # return 2 if error
    ping -I wwan0 -c1 -W 5 8.8.8.8 &>/dev/null
}

# entry of "mbn module"
mbn_loop() {
    while ! check_mbn; do
        echo "mbn not set, set it"
        set_mbn
		restart_module
		sleep 25
    done
    echo 'mbn check complete'
}

# entry of "SIM card maintenance module"
sim_status_loop() {
    # Current SIM card checking error times
    local current_sim_error_count=0
    # Current SIM clear frequency count
    local current_sim_frequency_clear_count=0
    local last_code

    while true; do
        debug 'do sim status check'
        check_sim_status
        last_code=$?
        # 10 means no sim
        # 2 means dbus error, SIM not inserted
        if [ "$last_code" -eq 10 ] || [ "$last_code" -eq 2 ]; then
            echo "sim card communication exception"
            restart_module
            return 1
        fi

        if ! check_sim_ccid; then
            if [ "$current_sim_frequency_clear_count" -ge 1 ]; then
                echo "fatal error: sim card status is abnormal even after clearing frequancy data"
                return 1
            else
                if [ "$current_sim_error_count" -ge "$MAX_SIM_ERROR_COUNT" ]; then
                    echo "sim error count exceed $MAX_SIM_ERROR_COUNT, clear modem frequency data"
                    frequency_clear
                    ((current_sim_frequency_clear_count++))
                else
                    ((current_sim_error_count++))
                fi
                echo "restart modem module due to sim card problem"

                # hard reset 4G module when can't connect network after 2th At reset 4G module. 
                if [ "$current_sim_error_count" -ge 3 ]; then
                    hard_reset
                else
                    restart_module
                fi
            fi
        else
            echo "sim status no problem"
            return 0
        fi
    done
}

# 
network_check_loop() {
    # Current ping check error times
    local current_ping_error_count=0
    # Current frequency point check error times
    local current_frequancy_error_count=0
    # Current frequency clearing times
    local current_frequancy_clear_count=0

    while true; do
        debug "do ping network check"
        if ! ping_network; then
            if [ "$current_frequancy_clear_count" -ge 1 ]; then
				# Frequency point fault is greater than or equal to 1, abnormal end
				# Then enter next 8h loop
                echo "fatal error: can't access network after clearing frequancy data"
                return 1
            else
                ((current_ping_error_count++))
                if [ "$current_ping_error_count" -ge "$MAX_PING_ERROR_COUNT" ]; then

                    if [ "$current_frequancy_error_count" -ge "$CURRENT_MAX_FREQUENCY_ERROR_COUNT" ]; then
                        echo "restart module count reach max:$CURRENT_MAX_FREQUENCY_ERROR_COUNT, clear modem frequancy data"
                        frequency_clear
                        ((current_frequancy_clear_count++))

                        ((CURRENT_MAX_FREQUENCY_ERROR_COUNT++))
                        if [ "$CURRENT_MAX_FREQUENCY_ERROR_COUNT" -gt "$MAX_FREQUENCY_ERROR_COUNT_MAX" ]; then
                            CURRENT_MAX_FREQUENCY_ERROR_COUNT=$MAX_FREQUENCY_ERROR_COUNT_MAX
                        fi
                    fi

                    echo "ping error count reach max:$MAX_PING_ERROR_COUNT, restart modem module"
                    restart_module
                    ((current_frequancy_error_count++))
                    current_ping_error_count=0
                    echo "will ping network again in $PING_INTERVAL"
                else
                    echo "can't access network via cellular $current_ping_error_count times, will ping network again in $PING_INTERVAL"
                fi
            fi
        else
            current_ping_error_count=0
            current_frequancy_error_count=0
            CURRENT_MAX_FREQUENCY_ERROR_COUNT=${MAX_FREQUENCY_ERROR_COUNT_MIN}
            echo "cellular network no problem, will ping network again in $PING_INTERVAL"
        fi
        sleep "$PING_INTERVAL"
    done
}

# used for tested respective modules
# four module:"main program module","mbn module","frequency maintenance module","SIM card maintenance module"
jump_run() {
    local current_step=$1
    shift
    if [ -n "$JUMP" ] && [ "$JUMP" -eq "$current_step" ]; then
        if [ "$current_step" -eq 0 ]; then
            echo "jump to mbn check loop"
        elif [ "$current_step" -eq 1 ]; then
            echo "jump to sim status loop"
        elif [ "$current_step" -eq 2 ]; then
            echo "jump to network check loop"
        fi
    fi
    if [ -z "$JUMP" ] || [ "$current_step" -ge "$JUMP" ]; then
        "$@"
    fi
}

# process of switching between four modules:"main program module","mbn module","frequency maintenance module","SIM card maintenance module"
loop_once() {
    get_modem_index

    debug 'start check mbn'
    jump_run 0 mbn_loop || {
        debug 'mbn failed'
        return 1
    }
    debug 'check mbn success'
    debug 'check sim status'
    jump_run 1 sim_status_loop || {
        debug 'check sim status failed'
        return 1
    }
    debug 'check sim status success'

    debug 'check network'
    jump_run 2 network_check_loop || {
        debug 'check network failed'
        return 1
    }
    debug 'check network success'
}

# entry of "main program module"
main_loop() {
    debug 'loop start'

    while true; do
        loop_once

        if [ -n "$JUMP" ]; then
            echo "stop loop because of step jump"
            break
        fi

        echo "sleep $CHECK_INTERVAL for next loop"
        sleep "$CHECK_INTERVAL"
    done

}

print_time_settings(){
    local ping_interval_num
    local ping_interval_unit
    local check_interval_num
    local check_interval_unit

    ping_interval_num=${PING_INTERVAL%[smhd]}
    ping_interval_unit=${PING_INTERVAL#"$ping_interval_num"}
    check_interval_num=${CHECK_INTERVAL%[smhd]}
    check_interval_unit=${CHECK_INTERVAL#"$check_interval_num"}
    
    echo "Environments:
    CHECK_INTERVAL: ${CHECK_INTERVAL}.
    PING_INTERVAL: ${PING_INTERVAL}.
    MAX_SIM_ERROR_COUNT: ${MAX_SIM_ERROR_COUNT}.
    MAX_PING_ERROR_COUNT: ${MAX_PING_ERROR_COUNT}.
    MAX_FREQUENCY_ERROR_COUNT_MIN: ${MAX_FREQUENCY_ERROR_COUNT_MIN}.
    MAX_FREQUENCY_ERROR_COUNT_MAX: ${MAX_FREQUENCY_ERROR_COUNT_MAX}.

    Frequancy clear interval in sim status check: $((MAX_SIM_ERROR_COUNT * check_interval_num))$check_interval_unit
    Min frequancy clear interval in ping network check: $((ping_interval_num * MAX_PING_ERROR_COUNT * MAX_FREQUENCY_ERROR_COUNT_MIN))$ping_interval_unit
    Max frequancy clear interval in ping network check: $((ping_interval_num * MAX_PING_ERROR_COUNT * MAX_FREQUENCY_ERROR_COUNT_MAX))$ping_interval_unit
"
}

usage() {
    echo "Cellular guard script
    Usage: $0 [OPTIONS]

OPTIONS:
    * -h,--help: Print this.
    * -x,--debug [0|1]: 0: output current step, 1: set -x, output all script steps.
    * -j,--jump <step>: Jump to step and exit. 0: mbn check; 1: sim status check; 2: network ping check.
    * --at <command>: Send AT command, get output and exit.
    * --source: I only need sourcing functions, don't run main loop.
"
}

while [[ $# -gt 0 ]]; do
    case $1 in
    -j | --jump)
        JUMP=$2
        if [[ ! $JUMP =~ ^[0-4]$ ]]; then
            echo "error usage of jump."
            usage
            exit 1
        fi
        shift
        ;;
    -x | --debug)
        DEBUG=$2
        if [[ ! $DEBUG =~ ^[0-1]$ ]]; then
            echo "error usage of debug."
            usage
            exit 1
        fi
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    --at)
        AT_send "$2"
        exit $?
        ;;
    --source)
        SOURCE_MODE=y
        ;;
    *)
        echo "Unknown option: $1"
        ;;
    esac
    shift
done

if [ "$DEBUG" = '1' ]; then
    set -x
fi

if [ "$SOURCE_MODE" != y ]; then
    print_time_settings
    main_loop
fi
