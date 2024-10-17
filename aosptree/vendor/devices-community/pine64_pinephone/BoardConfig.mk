# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2023 The GloDroid project

BC_PATH := $(patsubst $(CURDIR)/%,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include glodroid/configuration/common/board-common.mk

BOARD_VENDOR_SEPOLICY_DIRS += $(BC_PATH)/sepolicy/vendor

BOARD_KERNEL_SRC_DIR := glodroid/kernel/common-android14-6.1-lts
KERNEL_DEFCONFIG := $(BC_PATH)/kernel.defconfig
KERNEL_FRAGMENTS := glodroid/configuration/platform/common/sunxi/a64_overlay.config
KERNEL_DTB_FILES := allwinner/sun50i-a64-pinephone-1.1.dtb allwinner/sun50i-a64-pinephone-1.2.dtb

BOARD_KERNEL_PATCHES_DIRS := \
    $(BC_PATH)/patches-kernel/megi-audio-6.1     \
    $(BC_PATH)/patches-kernel/megi-bt-6.1        \
    $(BC_PATH)/patches-kernel/megi-drm-6.1       \
    $(BC_PATH)/patches-kernel/megi-fixes-6.1     \
    $(BC_PATH)/patches-kernel/megi-pp-6.1        \
    $(BC_PATH)/patches-kernel/megi-samuel-6.1    \
    $(BC_PATH)/patches-kernel/megi-wifi-6.1      \
    $(BC_PATH)/patches-kernel/megi-anx-6.1       \
    $(BC_PATH)/patches-kernel/megi-axp-6.1       \
    $(BC_PATH)/patches-kernel/megi-cam-6.1       \
    $(BC_PATH)/patches-kernel/megi-err-6.1       \
    $(BC_PATH)/patches-kernel/megi-modem-6.1     \
    $(BC_PATH)/patches-kernel/megi-speed-6.1     \
    $(BC_PATH)/patches-kernel/glodroid-6.1       \
    $(BC_PATH)/patches-kernel/glodroid-drm-6.1   \

GD_BOOTSCRIPT_OVERLAY_DEVICE := $(BC_PATH)/boot/bootscript_device_overlay.h

BOARD_FFMPEG_ENABLE_REQUEST_API := true
BOARD_FFMPEG_KERNEL_HEADERS_DIR := $(BC_PATH)/codecs/request_api_headers_v4
