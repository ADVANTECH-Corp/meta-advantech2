#!/bin/bash

IIO_DEV_NAME=$1
IIO_TEST_CHANNEL=$2
IIO_ACCESS_NODE=""
IIO_REG_TABLE_CONF=""

# Function to display usage instructions
show_help() {
    echo "Usage: $0 <IIO_DEV_NAME> <IIO_TEST_CHANNEL>"
    echo "  <IIO_DEV_NAME>: Must be 'iio:device1' or 'iio:device2'"
    echo "  <IIO_TEST_CHANNEL>: Must be 0 or 1"
    echo ""
    echo "This script reads a configuration file for the specified IIO device and channel,"
    echo "writes values from the config to the IIO debug direct register access, and reads the result."
    echo ""
    echo "Example:"
    echo "  $0 iio:device1 0"
}

# Check for --help flag
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

IIO_ACCESS_NODE="/sys/kernel/debug/iio/$IIO_DEV_NAME/direct_reg_access"
IIO_REG_TABLE_CONF="/tools/rtd/AD7124_REG_CHN$IIO_TEST_CHANNEL.conf"
echo $IIO_ACCESS_NODE $IIO_REG_TABLE_CONF

# Read the configuration file and write register values
while IFS= read -r line; do
    line=${line//[\{\},]/}
    IFS=', ' read -r col1 col2 _ col4 <<< "$line"
    if [ "$col4" != "2" ]; then
        #echo "Column 1: $col1, Column 2: $col2"
        echo $col1 $col2 > $IIO_ACCESS_NODE
        echo "REG $col1 => VALUE `cat $IIO_ACCESS_NODE`"
    fi
done < $IIO_REG_TABLE_CONF
