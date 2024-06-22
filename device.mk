#
# Copyright (C) 2018-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/lge/joan

# Inherit common repository
$(call inherit-product, device/lge/joan-common/joan-common.mk)

# NFC
PRODUCT_PACKAGES += \
    android.hardware.nfc@1.1-service

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/libnfc-nci.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    $(DEVICE_PATH)/configs/libnfc-nxp.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nxp.conf

# Releasetools
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/releasetools/device_check.sh:install/bin/device_check.sh

PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Inherit proprietary blobs
$(call inherit-product, vendor/lge/joan/joan-vendor.mk)
