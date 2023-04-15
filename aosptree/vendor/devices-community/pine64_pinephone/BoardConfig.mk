# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2023 The GloDroid project

BC_PATH := $(patsubst $(CURDIR)/%,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include glodroid/configuration/common/board-common.mk

BOARD_VENDOR_SEPOLICY_DIRS += $(BC_PATH)/sepolicy/vendor

# Apply mesa3d patches to reduce CPU load during frame processing.
BOARD_MESA3D_PATCHES_DIRS += glodroid/configuration/common/graphics/patches-mesa3d_slowgpu

BOARD_KERNEL_SRC_DIR := glodroid/kernel/common-android13-5.15-lts
KERNEL_DEFCONFIG := $(BC_PATH)/kernel.defconfig
KERNEL_FRAGMENTS := glodroid/configuration/platform/common/sunxi/a64_overlay.config

BOARD_KERNEL_PATCHES_DIRS := \
    $(BC_PATH)/patches-kernel/megi-audio-5.15     \
    $(BC_PATH)/patches-kernel/megi-bt-5.15        \
    $(BC_PATH)/patches-kernel/megi-drm-5.15       \
    $(BC_PATH)/patches-kernel/megi-fixes-5.15     \
    $(BC_PATH)/patches-kernel/megi-pp-5.15        \
    $(BC_PATH)/patches-kernel/megi-samuel-5.15    \
    $(BC_PATH)/patches-kernel/megi-wifi-5.15      \
    $(BC_PATH)/patches-kernel/megi-anx-5.15       \
    $(BC_PATH)/patches-kernel/megi-axp-5.15       \
    $(BC_PATH)/patches-kernel/megi-cam-5.15       \
    $(BC_PATH)/patches-kernel/megi-err-5.15       \
    $(BC_PATH)/patches-kernel/megi-modem-5.15     \
    $(BC_PATH)/patches-kernel/megi-speed-5.15     \
    $(BC_PATH)/patches-kernel/glodroid-5.15       \
    glodroid/configuration/patches/kernel/android13-5.15-2023-01/sun4i-drm \

GD_BOOTSCRIPT_OVERLAY_DEVICE := $(BC_PATH)/boot/bootscript_device_overlay.h

BOARD_DRMHWCOMPOSER_PATCHES_DIRS += glodroid/configuration/common/graphics/patches-drm_hwcomposer-experimental
