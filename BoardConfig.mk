# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2019 The Android Open-Source Project

include glodroid/configuration/common/board-common.mk

BOARD_VENDOR_SEPOLICY_DIRS += glodroid/devices-community/pine64-pinephone/sepolicy/vendor

# Apply mesa3d patches to reduce CPU load during frame processing.
BOARD_MESA3D_PATCHES_DIRS += glodroid/configuration/patches/vendor/mesa3d_slowgpu

BOARD_KERNEL_SRC_DIR := glodroid/kernel/common-android13-5.15-lts
KERNEL_DEFCONFIG := glodroid/devices-community/pine64-pinephone/kernel.defconfig
KERNEL_FRAGMENTS := glodroid/configuration/platform/common/sunxi/a64_overlay.config

BOARD_KERNEL_PATCHES_DIRS := \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-audio-5.15     \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-bt-5.15        \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-drm-5.15       \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-fixes-5.15     \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-pp-5.15        \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-samuel-5.15    \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-wifi-5.15      \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-anx-5.15       \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-axp-5.15       \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-cam-5.15       \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-err-5.15       \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-modem-5.15     \
    glodroid/devices-community/pine64-pinephone/patches-kernel/megi-speed-5.15     \
    glodroid/devices-community/pine64-pinephone/patches-kernel/glodroid-5.15       \
    glodroid/configuration/patches/kernel/android13-5.15-2023-01/sun4i-drm \
