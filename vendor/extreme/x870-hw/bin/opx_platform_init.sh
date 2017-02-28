#!/bin/bash

# Copyright (c) 2017 Extreme Networks, Inc.
#
# See the Apache Version 2.0 License for specific language governing
# permissions and limitations under the License.
#

set +x
set -e

function wait_for {
    while [ ! -e $1 ] ; do
        echo "Waiting for $1"
    done
}

function add_device {
    while [ ! -e $2 ] ; do
        echo "Waiting for $2"
    done
    while [ ! -e $3 ] ; do
        echo "$1" >> $2
        echo "Instantiating device $1"
        for ((i=1;i<=3;i++)) ; do
            if [ -e $3 ] ; then
                break
            fi
            sleep 1
        done
    done
}

add_device "pca9548 0x70" /sys/bus/i2c/devices/i2c-0/new_device /sys/bus/i2c/devices/i2c-9/new_device
add_device "pca9545 0x71" /sys/bus/i2c/devices/i2c-6/new_device /sys/bus/i2c/devices/i2c-13/new_device 
add_device "pca9548 0x72" /sys/bus/i2c/devices/i2c-8/new_device /sys/bus/i2c/devices/i2c-21/new_device
add_device "pca9548 0x73" /sys/bus/i2c/devices/i2c-21/new_device /sys/bus/i2c/devices/i2c-29/new_device
add_device "g751 0x4f" /sys/bus/i2c/devices/i2c-0/new_device /sys/bus/i2c/devices/0-004f/hwmon/hwmon*/temp1_input
add_device "lm75 0x4c" /sys/bus/i2c/devices/i2c-5/new_device /sys/bus/i2c/devices/5-004c/hwmon/hwmon*/temp1_input
add_device "lm75 0x4d" /sys/bus/i2c/devices/i2c-4/new_device /sys/bus/i2c/devices/4-004d/hwmon/hwmon*/temp1_input

# Put firmware verions of PLDs in a file
FIRMWARE_VERSION_FILE=/var/log/firmware_versions
rm -rf ${FIRMWARE_VERSION_FILE}
echo "BIOS: `dmidecode -s bios-vendor ` `dmidecode -s bios-version `" > $FIRMWARE_VERSION_FILE
echo "System CPLD: $((`i2cget -y 9 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Power CPLD: $((`i2cget -y 0 0x5e 0` & 0xf)) $((`i2cget -y 0 0x5e 1`))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD0: $((`i2cget -y 14 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD1: $((`i2cget -y 15 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD2: $((`i2cget -y 16 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
echo "Port CPLD3: $((`i2cget -y 17 0x5f 0` & 0xf))" >> $FIRMWARE_VERSION_FILE
