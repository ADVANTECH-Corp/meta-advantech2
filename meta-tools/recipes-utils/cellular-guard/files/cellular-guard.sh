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
trap 'leave' EXIT

#  ---------- global variables begin ------------

declare -r STATUS_FILE_PATH='/mnt/data/cellular_guard/status'
declare -r LOG_FILE_PATH='/mnt/data/cellular_guard/cellular_guard.log'

# default not log to file
PERSISTENT_LOGGING=${PERSISTENT_LOGGING:-n}
# max log file size, unit KiB
MAX_LOG_SIZE=${MAX_LOG_SIZE:-100}

# Used for delay time of "main program module" loop, default:8h
CHECK_INTERVAL=${CHECK_INTERVAL:-1h}

# the interval of ping error is: 60x(4-1)=3 minutes, 600x(4-1)=30 minutes, 600x(4-1)=30 minutes, 3600x(4-1)=3 hours
# ping gradient interval time
PING_INTERVALS=${PING_INTERVALS:-'60 600 600 3600'}
IFS=" " read -r -a PING_INTERVALS_ARRAY <<<"$PING_INTERVALS"
# Used for Record the number of network check failures in "frequency maintenance module"
MAX_PING_ERROR_COUNT=${MAX_PING_ERROR_COUNT:-'4 4 4 4'}
IFS=" " read -r -a MAX_PING_ERROR_COUNT_ARRAY <<<"$MAX_PING_ERROR_COUNT"

PING_INTERVAL_NORMAL=${PING_INTERVAL_NORMAL:-10m}

# Minimum value of 4G module frequency clearing of "frequency maintenance module", default:3
MAX_FREQUENCY_ERROR_COUNT_MIN=${MAX_FREQUENCY_ERROR_COUNT_MIN:-3}

# Max value of 4G module frequency clearing of "frequency maintenance module", default:5
MAX_FREQUENCY_ERROR_COUNT_MAX=${MAX_FREQUENCY_ERROR_COUNT_MAX:-5}

# Used for trigger 4G module frequency clearing of "SIM card maintenance module", default:4
MAX_SIM_ERROR_COUNT=${MAX_SIM_ERROR_COUNT:-4}

# corrent num of modem manager
MODEM_INDEX=0
# count of 4G frequency clearing of "frequency maintenance module"
CURRENT_MAX_FREQUENCY_ERROR_COUNT=${MAX_FREQUENCY_ERROR_COUNT_MIN}

declare -r STATUS_OK='ok'
declare -r STATUS_SIM_ERROR10='sim_error10'
declare -r STATUS_SIM_ERROR='sim_error'
declare -r STATUS_NETWORK_ERROR='network_error'

# current cellular network status
# ok: network is ok
# sim_error: sim card error
# sim_error10: sim card not inserted
# network_error: can not ping network
CURRENT_STATUS=

# from parameters
JUMP=
SOURCE_MODE=n
DEBUG=
#  ---------- global variables end ------------

# log message to file with date prefix
log_to_file() {
    if [ "$PERSISTENT_LOGGING" != y ]; then
        return
    fi
    if [ -z "$MAX_LOG_SIZE" ] || [ $MAX_LOG_SIZE -eq 0 ]; then
        return
    fi
    # return if no permission
    touch $LOG_FILE_PATH &>/dev/null || return
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $*" >>$LOG_FILE_PATH
}

# both output message to console and file
tee_log() {
    while IFS='' read -r line; do
        echo "$line"
        log_to_file "$line"
    done
}

# if --debug 0, print debug info to console
# else log debug info to log file
debug() {
    if [ "$DEBUG" = '0' ]; then
        # redirect to stderr to avoid capture of subshell output
        echo "$*" >&2
    else
        log_to_file "$*"
    fi
}

update_status() {
    if [ "$PERSISTENT_LOGGING" != y ]; then
        return
    fi
    local status="$1"
    if [ "$status" != "$CURRENT_STATUS" ]; then
        echo "status changed from $CURRENT_STATUS to $status"
        CURRENT_STATUS="$status"
        mkdir -p "$(dirname $STATUS_FILE_PATH)"
        echo -n "$*" >"$STATUS_FILE_PATH"
    fi
}

# if the log exceeds the max size, halve it
truncate_log() {
    local log_size
    if [ -f $LOG_FILE_PATH ]; then
        if [ -z "$MAX_LOG_SIZE" ] || [ $MAX_LOG_SIZE -eq 0 ]; then
            return
        fi
        sync "${LOG_FILE_PATH}"
        log_size=$(du -Lks ${LOG_FILE_PATH} | awk '{print $1}')
        if [ "$log_size" -gt "$MAX_LOG_SIZE" ]; then
            log_to_file "truncate log"
            local line_num
            line_num=$(wc -l <$LOG_FILE_PATH)
            tail -n $((line_num / 2)) "${LOG_FILE_PATH}" >"${LOG_FILE_PATH}.save"
            mv "${LOG_FILE_PATH}.save" "${LOG_FILE_PATH}"
            sync "${LOG_FILE_PATH}"
        fi
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
    sleep 60
}

restart_NetworkManager() {
    restart_service NetworkManager
    # wait for service restart
    sleep 60
}

# do not run this in a subshell $() or backticks ``
# because the modification of MODEM_INDEX will not be effective
get_modem_index() {
    local index check_count=0
    while true; do
        index=$(
            dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.ModemManager1 \
                /org/freedesktop/ModemManager1 org.freedesktop.DBus.ObjectManager.GetManagedObjects |
                grep -Eo '/org/freedesktop/ModemManager1/Modem/[0-9]+' |
                sed -En 's|/org/freedesktop/ModemManager1/Modem/([0-9]+)|\1|p' | head -1
        )
        # retry if modem manager is not start or modem is not ready
        if [ $? -ne 0 ] || [ -z "$index" ]; then
            # 3 minutes can't get modem index restart ModemManager
            if [ $check_count -gt 36 ]; then
                echo "get modem index timeout, restart ModemManager"
                restart_ModemManager
                check_count=0
            fi
            sleep 5
            ((check_count++))
        else
            if [ "$MODEM_INDEX" != "$index" ]; then
                debug "modem index changed from '$MODEM_INDEX' to '$index'"
                MODEM_INDEX="$index"
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
    local at_result

    # use ModemManager Api not echo to /dev/ttyUSB2 directly to avoid device occupancy conflicts

    # dbus-send:
    # if send: AT+QENG="SERVINGCELL"
    # output:  +QENG: "servingcell","NOCONN","LTE","FDD",262,01,25A5507,212,500,1,5,5,67BD,-93,-7,-65,15,28
    at_result=$(
        dbus-send --print-reply=literal --type=method_call --system --dest=org.freedesktop.ModemManager1 \
            /org/freedesktop/ModemManager1/Modem/"$MODEM_INDEX" org.freedesktop.ModemManager1.Modem.Command \
            string:"$at_command" uint32:2000 | sed -e 's|^[[:space:]]*||'
    )

    if [ $? -ne 0 ]; then
        return 1
    fi

    # will return like: "servingcell","NOCONN","LTE","FDD",262,01,25A5507,212,500,1,5,5,67BD,-93,-7,-65,15,28
    cut -d: -f2- <<<"$at_result" | sed -e 's|^[[:space:]]*||'
}

# AT+QMBNCFG="AutoSel"
# MBNCFG="AutoSel",1
check_mbn() {
    local result
    get_modem_index
    if ! result=$(AT_send 'AT+QMBNCFG="AutoSel"'); then
        return 1
    fi
    debug "AT+QMBNCFG=\"AutoSel\" result:$result"
    echo "$result" | grep -Eq '1$'
}

# AT+QMBNCFG="AutoSel",1
set_mbn() {
    get_modem_index
    AT_send 'AT+QMBNCFG="AutoSel",1' &>/dev/null
}

# AT+CPIN?
# READY found
# sim card
check_sim_status() {
    local result
    get_modem_index
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
    get_modem_index
    if ! result=$(AT_send 'AT+CCID'); then
        return 2
    fi
    debug "AT+CCID result:$result"

    # ERROR: 13: sim error

    if ! echo "$result" | grep -Eq '^[0-9]+$'; then
        return 1
    fi
}

# AT+CSQ
# use the return value as signal quality
# return 0 means get signal quality failed
get_signal_quality() {
    local result
    get_modem_index || return 0
    if ! result=$(AT_send 'AT+CSQ'); then
        return 0
    fi
    debug "AT+CSQ result:$result"
    return "$(echo "$result" | cut -d, -f1)"
}

# Network resident of 4G module
check_registration() {
    local result
    get_modem_index
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
    get_modem_index
    AT_send 'AT+CFUN=1,1' &>/dev/null
    # wait for modem restart
    sleep 5
}

# frequency clearing
frequency_clear() {
    get_modem_index
    # clear 4G frequency
    AT_send 'AT+QNVFD="/nv/reg_files/modem/lte/rrc/csp/acq_db"' &>/dev/null
    # clear 2G frequency
    AT_send 'AT+QCFG="nwoptmz/acq",0' &>/dev/null
}

# check nerwork, timeout 5s
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
            update_status $STATUS_SIM_ERROR10
            restart_module
            return 1
        fi

        # do a check for log
        check_registration || true

        if ! check_sim_ccid; then

            update_status $STATUS_SIM_ERROR
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

# ignore number if is zero
# remove 's' suffix if is plural
humanize_unit() {
    local number=$1
    local unit=$2
    if [ "$number" -eq 0 ]; then
        return
    elif [ "$number" -eq 1 ]; then
        echo " $number ${unit%s}"
    else
        echo " $number $unit"
    fi
}

# format seconds number to human friendly unit
# like 3661 -> 1 hour 1 minute 1 second
# 7322 -> 2 hours 2 minutes 1 seconds
humanize_interval() {
    local seconds=$1
    if [ -z "$seconds" ]; then
        return
    fi
    if [ "$seconds" -ge 3600 ]; then
        echo -n "$(humanize_unit $((seconds / 3600)) hours)"
        echo -n "$(humanize_unit $(((seconds % 3600) / 60)) minutes)"
        echo -n "$(humanize_unit $((seconds % 60)) seconds)"
    elif [ "$seconds" -ge 60 ]; then
        echo -n "$(humanize_unit $((seconds / 60)) minutes)"
        echo -n "$(humanize_unit $((seconds % 60)) seconds)"
    else
        humanize_unit "$((seconds % 60))" seconds
    fi
}

#
network_check_loop() {
    # Current ping check error times
    local current_ping_error_count=0
    # Current frequency point check error times
    local current_frequancy_error_count=0
    # Current frequency clearing times
    local current_frequancy_clear_count=0
    # current interval index,
    # current ping interval is ${PING_INTERVALS_ARRAY[$current_interval_index]}
    # current max ping error count is ${MAX_PING_ERROR_COUNT_ARRAY[$current_interval_index]}
    local current_interval_index=0
    local current_sleep_interval

    while true; do
        debug "do ping network check"
        if ! ping_network; then
            update_status $STATUS_NETWORK_ERROR
            local signal_quality
            get_signal_quality
            signal_quality=$?

            # the return value of 'get_signal_quality' is the signal value
            # if is 0, means get signal failed
            if [ $signal_quality -ne 0 ]; then
                # signal quality is 99, means no signal
                # or less than 15, means signal is too weak
                if [ "$signal_quality" = 99 ] || [ "$signal_quality" -lt 15 ]; then
                    echo "low signal quality: $signal_quality"
                else
                    log_to_file "ping network error, signal quality: $signal_quality"
                fi
            fi

            if [ "$current_frequancy_clear_count" -ge 1 ]; then
                # Frequency point fault is greater than or equal to 1, abnormal end
                # Then enter next 8h loop
                echo "fatal error: can't access network after clearing frequancy data"
                return 1
            else
                ((current_ping_error_count++))
                if [ "$current_ping_error_count" -ge "${MAX_PING_ERROR_COUNT_ARRAY[$current_interval_index]}" ]; then

                    ((current_frequancy_error_count++))
                    if [ "$current_frequancy_error_count" -ge "$CURRENT_MAX_FREQUENCY_ERROR_COUNT" ]; then
                        echo "restart module count reach max:$CURRENT_MAX_FREQUENCY_ERROR_COUNT, clear modem frequancy data"
                        frequency_clear
                        ((current_frequancy_clear_count++))

                        ((CURRENT_MAX_FREQUENCY_ERROR_COUNT++))
                        if [ "$CURRENT_MAX_FREQUENCY_ERROR_COUNT" -gt "$MAX_FREQUENCY_ERROR_COUNT_MAX" ]; then
                            CURRENT_MAX_FREQUENCY_ERROR_COUNT=$MAX_FREQUENCY_ERROR_COUNT_MAX
                        fi
                    fi

                    echo "can't access network via cellular reach max:${MAX_PING_ERROR_COUNT_ARRAY[$current_interval_index]}, restart modem module"
                    restart_module
                    current_ping_error_count=0

                    ((current_interval_index++))
                    if (("$current_interval_index" >= "${#PING_INTERVALS_ARRAY[@]}")); then
                        current_interval_index=$(("${#PING_INTERVALS_ARRAY[@]}" - 1))
                    fi
                    current_sleep_interval=${PING_INTERVALS_ARRAY[$current_interval_index]}
                    echo "will ping network again in$(humanize_interval "$current_sleep_interval")"
                else
                    current_sleep_interval=${PING_INTERVALS_ARRAY[$current_interval_index]}
                    echo "can't access network via cellular $current_ping_error_count times," \
                        "will ping network again in$(humanize_interval "$current_sleep_interval")"
                fi
            fi
        else
            current_interval_index=0
            current_ping_error_count=0
            current_frequancy_error_count=0
            CURRENT_MAX_FREQUENCY_ERROR_COUNT=${MAX_FREQUENCY_ERROR_COUNT_MIN}
            update_status $STATUS_OK
            # use normal interval
            current_sleep_interval=${PING_INTERVAL_NORMAL}
            echo "cellular network no problem, will ping network again in $current_sleep_interval"
        fi
        truncate_log
        sleep "$current_sleep_interval"
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
    if [ ${#PING_INTERVALS_ARRAY[*]} -ne ${#MAX_PING_ERROR_COUNT_ARRAY[*]} ]; then
        echo "PING_INTERVALS length:${#PING_INTERVALS_ARRAY[*]}" \
            "and MAX_PING_ERROR_COUNT length:${#MAX_PING_ERROR_COUNT_ARRAY[*]} must be same "
        return 1
    fi
    debug 'loop start'

    while true; do
        loop_once

        if [ -n "$JUMP" ]; then
            echo "stop loop because of step jump"
            break
        fi

        echo "sleep $CHECK_INTERVAL for next loop"
        sleep "$CHECK_INTERVAL"
        truncate_log
    done
}

print_time_settings() {
    local check_interval_num check_interval_unit \
        max_frequancy_clear_interval_min max_frequancy_clear_interval_max \
        num ping_interval ping_count i=0

    check_interval_num=${CHECK_INTERVAL%[smhd]}
    check_interval_unit=${CHECK_INTERVAL#"$check_interval_num"}

    while ((i < MAX_FREQUENCY_ERROR_COUNT_MAX)); do
        if ((i >= ${#PING_INTERVALS_ARRAY[@]})); then
            ping_interval=${PING_INTERVALS_ARRAY[${#PING_INTERVALS_ARRAY[@]} - 1]}
            ping_count=${MAX_PING_ERROR_COUNT_ARRAY[${#PING_INTERVALS_ARRAY[@]} - 1]}
        else
            ping_interval=${PING_INTERVALS_ARRAY[$i]}
            ping_count=${MAX_PING_ERROR_COUNT_ARRAY[$i]}
        fi
        ((num += ping_interval * (ping_count - 1)))
        if ((i == MAX_FREQUENCY_ERROR_COUNT_MIN - 1)); then
            max_frequancy_clear_interval_min=$num
        fi
        ((i++))
    done
    max_frequancy_clear_interval_max=$num

    echo "Environments:
    PERSISTENT_LOGGING: ${PERSISTENT_LOGGING}.
    CHECK_INTERVAL: ${CHECK_INTERVAL}.
    MAX_SIM_ERROR_COUNT: ${MAX_SIM_ERROR_COUNT}.
    PING_INTERVALS: ${PING_INTERVALS_ARRAY[*]}.
    PING_INTERVAL_NORMAL: ${PING_INTERVAL_NORMAL}.
    MAX_PING_ERROR_COUNT: ${MAX_PING_ERROR_COUNT_ARRAY[*]}.
    MAX_FREQUENCY_ERROR_COUNT_MIN: ${MAX_FREQUENCY_ERROR_COUNT_MIN}.
    MAX_FREQUENCY_ERROR_COUNT_MAX: ${MAX_FREQUENCY_ERROR_COUNT_MAX}.

    Frequancy clear interval in sim status check: $(((MAX_SIM_ERROR_COUNT - 1) * check_interval_num))${check_interval_unit}.
    Min frequancy clear interval in ping network check: $(humanize_interval $max_frequancy_clear_interval_min).
    Max frequancy clear interval in ping network check: $(humanize_interval $max_frequancy_clear_interval_max).
"
    # Block for some time to flush the log file
    sleep 0.5
}

leave() {
    log_to_file "cellular guard exited"
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
        if [[ ! $JUMP =~ ^[0-2]$ ]]; then
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
    if [ "$PERSISTENT_LOGGING" = y ]; then
        # redirect log to file
        if mkdir -p "$(dirname $LOG_FILE_PATH)"; then
            if [ "$DEBUG" = '1' ]; then
                echo "no log to file in debug=1 mode"
            else
                echo "log to $LOG_FILE_PATH"
                exec &> >(tee_log)
            fi
        else
            echo "can't create log file path $(dirname $LOG_FILE_PATH), log to stdout only"
        fi
    fi

    print_time_settings
    if [ -z "$JUMP" ]; then
        echo "main loop will start after 10 minites"
        sleep 10m
    else
        echo "jump to $JUMP, skip the first waiting"
    fi

    echo "main loop start"
    main_loop
fi
