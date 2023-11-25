# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(LOCAL_PATH)/device.mk)

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a15

# Product
PRODUCT_BOARD_PLATFORM := sunxi
PRODUCT_NAME := pine64_pinephone
PRODUCT_DEVICE := pine64_pinephone
PRODUCT_BRAND := Pine64
PRODUCT_MODEL := PinePhone
PRODUCT_MANUFACTURER := Pine64
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := pinephone_defconfig
ATF_PLAT        := sun50i_a64

CRUST_FIRMWARE_DEFCONFIG := pinephone_defconfig

GD_LCD_DENSITY := 269
GD_AUDIOPOLICY_FILE := vendor/devices-community/pine64_pinephone/etc/audio_policy_configuration.xml
# GD_USE_RS_HWCOMPOSER := true
