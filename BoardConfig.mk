#
# Copyright (C) 2018-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from joan-common
include device/lge/joan-common/BoardConfigCommon.mk

DEVICE_PATH := device/lge/joan

TARGET_OTA_ASSERT_DEVICE := v30,h930,joan

# inherit from the proprietary version
include vendor/lge/joan/BoardConfigVendor.mk
