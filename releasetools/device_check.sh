#!/sbin/sh
#
# Copyright (C) 2020-2021 LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

echo "Checking if we are on a H932 (not H932PR). H932 requires specific graphics blobs."

# Check for toy/busybox
TOYBOX=/sbin/toybox
BUSYBOX=/sbin/busybox

mkdir -p /mnt/system

if test -f "$TOYBOX"; then
    toybox mount /dev/block/bootdevice/by-name/system -t ext4 /mnt/system
elif test -f "$BUSYBOX"; then
    busybox mount /dev/block/bootdevice/by-name/system -t ext4 /mnt/system
else
    /tmp/toybox mount /dev/block/bootdevice/by-name/system -t ext4 /mnt/system
fi

if cat /proc/cmdline | grep -q "LG-H932"; then
    echo "H932 detected, copying blobs..."
    mv /mnt/system/system/vendor/firmware/H932/* /mnt/system/system/vendor/firmware/
else
    echo "Not a H932, copy over the H930 specific graphics blobs"
    mv /mnt/system/system/vendor/firmware/H930/* /mnt/system/system/vendor/firmware/
fi

echo "Remove unneeded blobs"
rm -r /mnt/system/system/vendor/firmware/H930
rm -r /mnt/system/system/vendor/firmware/H932

echo "Set proper permissions for newly copied graphics blobs"
chmod 0644 /mnt/system/system/vendor/firmware/a540*
chown root:root /mnt/system/system/vendor/firmware/a540*
echo "including SELinux file contexts"
chcon u:object_r:firmware_file:s0 /mnt/system/system/vendor/firmware/a540*

if test -f "$TOYBOX"; then
    toybox umount /mnt/system
elif test -f "$BUSYBOX"; then
    busybox umount /mnt/system
else
    /tmp/toybox umount /mnt/system
fi
