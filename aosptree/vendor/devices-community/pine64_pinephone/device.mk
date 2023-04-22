# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, glodroid/configuration/common/device-common.mk)

# Firmware
PRODUCT_COPY_FILES += \
    glodroid/kernel-firmware/megous/rtl_bt/rtl8723cs_xx_fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_fw.bin \
    glodroid/kernel-firmware/megous/rtl_bt/rtl8723cs_xx_config.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/rtl_bt/rtl8723cs_xx_config.bin \
    glodroid/kernel-firmware/megous/anx7688-fw.bin:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/anx7688-fw.bin \
    glodroid/kernel-firmware/megous/regulatory.db:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/regulatory.db \
    glodroid/kernel-firmware/megous/regulatory.db.p7s:$(TARGET_COPY_OUT_VENDOR)/etc/firmware/regulatory.db.p7s \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/sensors.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/sensors.pinephone.rc \
    $(LOCAL_PATH)/etc/typec.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/typec.pinephone.rc \
    $(LOCAL_PATH)/etc/modem.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/modem.pinephone.rc \
    $(LOCAL_PATH)/etc/power.pinephone.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/power.pinephone.rc \
    $(LOCAL_PATH)/etc/uevent.device.rc:$(TARGET_COPY_OUT_VENDOR)/etc/uevent.device.rc \

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/etc/audio.pinephone.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.pine64_pinephone.xml \

# Lights HAL
PRODUCT_PACKAGES += \
    android.hardware.lights-service.pinephone \

# Vibrator HAL
PRODUCT_PACKAGES += \
    android.hardware.vibrator-service.pinephone \

PRODUCT_PACKAGES += \
    sensors.iio \
    android.hardware.sensors@1.0-impl:64 \
    android.hardware.sensors@1.0-service

# Checked by android.opengl.cts.OpenGlEsVersionTest#testOpenGlEsVersion. Required to run correct set of dEQP tests.
# 131072 == 0x00020000 == GLES v2.0
PRODUCT_VENDOR_PROPERTIES += \
    ro.opengles.version=131072

# RRO that disables round items in quicksetting menu to increase performance
PRODUCT_PACKAGES += \
    SystemUISlowGpu

PRODUCT_PACKAGES += \
    call-audio \

# Bluetooth
PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.device.class_of_device=90,2,12 \
    bluetooth.profile.asha.central.enabled=true \
    bluetooth.profile.a2dp.source.enabled=true \
    bluetooth.profile.avrcp.target.enabled=true \
    bluetooth.profile.bap.broadcast.assist.enabled=true \
    bluetooth.profile.bap.unicast.client.enabled=true \
    bluetooth.profile.bas.client.enabled=true \
    bluetooth.profile.csip.set_coordinator.enabled=true \
    bluetooth.profile.gatt.enabled=true \
    bluetooth.profile.hap.client.enabled=true \
    bluetooth.profile.hfp.ag.enabled=true \
    bluetooth.profile.hid.device.enabled=true \
    bluetooth.profile.hid.host.enabled=true \
    bluetooth.profile.map.server.enabled=true \
    bluetooth.profile.mcp.server.enabled=true \
    bluetooth.profile.opp.enabled=true \
    bluetooth.profile.pan.nap.enabled=true \
    bluetooth.profile.pan.panu.enabled=true \
    bluetooth.profile.pbap.server.enabled=true \
    bluetooth.profile.sap.server.enabled=true \
    bluetooth.profile.ccp.server.enabled=true \
    bluetooth.profile.vcp.controller.enabled=true \
    persist.bluetooth.a2dp_aac.vbr_supported=true \
