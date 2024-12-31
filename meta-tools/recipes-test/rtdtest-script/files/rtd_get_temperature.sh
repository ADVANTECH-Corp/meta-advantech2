#!/bin/bash

IIO_DEV_NAME=$1
IIO_TEST_CHANNEL=$2
IIO_RAW_NODE=""

# Function to display usage instructions
show_help() {
    echo "Usage: $0 <IIO_DEV_NAME> <IIO_TEST_CHANNEL>"
    echo "  <IIO_DEV_NAME>: Must be 'iio:device1' or 'iio:device2'"
    echo "  <IIO_TEST_CHANNEL>: Must be 0 or 1"
    echo ""
    echo "Example:"
    echo "  $0 iio:device1 0"
    echo ""
    echo "This script reads raw data from the specified IIO device and channel,"
    echo "then passes the raw value to the 'rtd_converter' tool."
}

if [ "$1" == "--help" ]; then
    show_help
    exit 0
fi

check_input() {

    if [ "$1" != "iio:device1" ] && [ "$1" != "iio:device2" ]; then
        echo "Device name must be 'iio:device1' or 'iio:device2'"
        exit 1
    fi

    if [ "$2" != "0" ] && [ "$2" != "1" ]; then
        echo "Specified channel ID must be 0 or 1."
        exit 1
    fi
}

# Validate input arguments
if [ -z "$IIO_DEV_NAME" ] || [ -z "$IIO_TEST_CHANNEL" ]; then
    echo "Error: Missing arguments."
    show_help
    exit 1
fi

check_input "$IIO_DEV_NAME" "$IIO_TEST_CHANNEL"

if [ "$IIO_TEST_CHANNEL" == "0" ]; then
    IIO_RAW_NODE="/sys/bus/iio/devices/$IIO_DEV_NAME/in_voltage2-voltage3_raw"
elif [ "$IIO_TEST_CHANNEL" == "1" ]; then
    IIO_RAW_NODE="/sys/bus/iio/devices/$IIO_DEV_NAME/in_voltage4-voltage5_raw"
fi

if [ ! -f "$IIO_RAW_NODE" ]; then
    echo "The specified IIO raw node does not exist: $IIO_RAW_NODE"
    exit 1
fi

# Read the raw value from the IIO node
RAW_VALUE=$(cat "$IIO_RAW_NODE")

# Call the rtd_converter with the raw value
/usr/bin/rtd_converter --sensor 1 --raw "$RAW_VALUE"
