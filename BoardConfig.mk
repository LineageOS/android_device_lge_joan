#
# Copyright (C) 2018-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/lge/joan

TARGET_OTA_ASSERT_DEVICE := v30,joan,h930,h932

# inherit from common repository
include device/lge/joan-common/BoardConfigCommon.mk

# Kernel
TARGET_KERNEL_CONFIG := lineageos_joan_defconfig

# Partition
BOARD_SUPER_PARTITION_SIZE := 5863636992
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 5859442688 # (BOARD_SUPER_PARTITION_SIZE - 4194304) 4MiB overhead

# Releasetools
TARGET_RELEASETOOLS_EXTENSIONS := $(DEVICE_PATH)/releasetools

# inherit from the proprietary version
include vendor/lge/joan/BoardConfigVendor.mk
