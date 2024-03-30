#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=joan
VENDOR=lge

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_FIRMWARE=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-firmware )
                ONLY_FIRMWARE=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    product/etc/permissions/vendor.qti.hardware.data.connection-V1.*-java.xml)
        sed -i "s/\"2\.0/\"1\.0/g" "${2}"
        ;;
    vendor/lib*/hw/audio.primary.msm8998.so)
        ${PATCHELF} --add-needed libprocessgroup.so "${2}"
        ;;
    vendor/lib/hw/camera.msm8998.so)
        sed -i "s/libandroid\.so/libui_shim\.so/g" "${2}"
        ${PATCHELF} --remove-needed libsensor.so "${2}"
        ${PATCHELF} --remove-needed libgui.so "${2}"
        ${PATCHELF} --remove-needed libui.so "${2}"
        ;;
    vendor/lib/libarcsoft_beauty_picselfie.so)
        ${PATCHELF} --remove-needed libandroid.so "${2}"
        ${PATCHELF} --remove-needed libjnigraphics.so "${2}"
        ${PATCHELF} --replace-needed libstdc++.so libstdc++_vendor.so "${2}"
        ;;
    vendor/lib/libfilm_emulation.so)
        ${PATCHELF} --remove-needed libjnigraphics.so "${2}"
        ${PATCHELF} --replace-needed libstdc++.so libstdc++_vendor.so "${2}"
        ;;
    vendor/lib/libmmcamera_bokeh.so)
        ${PATCHELF} --replace-needed libui.so libui_shim.so "${2}"
        ;;
    vendor/lib/libmpbase.so)
        ${PATCHELF} --remove-needed libandroid.so "${2}"
        ${PATCHELF} --replace-needed libstdc++.so libstdc++_vendor.so "${2}"
        ;;
    vendor/lib/libAutoContrast.so|vendor/lib/libSJFingerDetect.so|vendor/lib/libSJVideoNR.so|vendor/lib/libarcsoft_object_tracking.so|vendor/lib/libarcsoft_picselfie_algorithm.so|vendor/lib/libcinemaeffect.so|vendor/lib/libfilm_emulation_symphony.so|vendor/lib/liblghdri.so|vendor/lib/liblgmda.so|vendor/lib/libmorpho_image_stab31.so|vendor/lib/libmorpho_superzoom.so)
        ${PATCHELF} --replace-needed libstdc++.so libstdc++_vendor.so "${2}"
        ;;
    vendor/lib/sensors.ssc.so)
        sed -i "s/\x11\xf0\x9e\xf8/\x4d\xd2\x00\xbf/" "${2}"
        ;;
    vendor/lib64/sensors.ssc.so)
        sed -i "s/\xf2\x8b\xff\x97/\x2a\x00\x00\x14/" "${2}"
        ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

if [ -z "${ONLY_FIRMWARE}" ]; then
    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    extract "${MY_DIR}/proprietary-files_phoenix.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    extract "${MY_DIR}/proprietary-files_h930.txt" "${SRC}" "${KANG}" --section "${SECTION}"
    extract "${MY_DIR}/proprietary-files_h932.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

#if [ -z "${SECTION}" ]; then
#    extract_firmware "${MY_DIR}/proprietary-firmware.txt" "${SRC}"
#fi

"${MY_DIR}/setup-makefiles.sh"
