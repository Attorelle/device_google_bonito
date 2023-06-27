#
# Copyright (C) 2017 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_USERIMAGES_USE_F2FS := true

LOCAL_PATH := device/google/bonito

# define hardware platform
PRODUCT_PLATFORM := sdm670

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

include device/google/bonito/device.mk

# Bug 77867216
PRODUCT_PROPERTY_OVERRIDES += audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += vendor.audio.adm.buffering.ms=3
PRODUCT_PROPERTY_OVERRIDES += audio_hal.period_multiplier=2
PRODUCT_PROPERTY_OVERRIDES += af.fast_track_multiplier=1

# Set c2 codec in default
PRODUCT_PROPERTY_OVERRIDES += debug.stagefright.ccodec=4
PRODUCT_PROPERTY_OVERRIDES += debug.stagefright.omx_default_rank=512

# Setting vendor SPL
VENDOR_SECURITY_PATCH = 2022-05-05

# Set boot SPL
BOOT_SECURITY_PATCH = 2022-05-05

# MIDI feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Audio low latency feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml

# Pro audio feature
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml

# Enable AAudio MMAP/NOIRQ data path.
# 1 is AAUDIO_POLICY_NEVER  means only use Legacy path.
# 2 is AAUDIO_POLICY_AUTO   means try MMAP then fallback to Legacy path.
# 3 is AAUDIO_POLICY_ALWAYS means only use MMAP path.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_policy=2
# 1 is AAUDIO_POLICY_NEVER  means only use SHARED mode
# 2 is AAUDIO_POLICY_AUTO   means try EXCLUSIVE then fallback to SHARED mode.
# 3 is AAUDIO_POLICY_ALWAYS means only use EXCLUSIVE mode.
PRODUCT_PROPERTY_OVERRIDES += aaudio.mmap_exclusive_policy=2

# Increase the apparent size of a hardware burst from 1 msec to 2 msec.
# A "burst" is the number of frames processed at one time.
# That is an increase from 48 to 96 frames at 48000 Hz.
# The DSP will still be bursting at 48 frames but AAudio will think the burst is 96 frames.
# A low number, like 48, might increase power consumption or stress the system.
PRODUCT_PROPERTY_OVERRIDES += aaudio.hw_burst_min_usec=2000

# Set lmkd options
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.low_ram = false \
    ro.lmk.log_stats = true \

# A2DP offload enabled for compilation
AUDIO_FEATURE_ENABLED_A2DP_OFFLOAD := true

# A2DP offload supported
PRODUCT_PROPERTY_OVERRIDES += \
ro.bluetooth.a2dp_offload.supported=true

# A2DP offload disabled (UI toggle property)
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.disabled=false

# A2DP offload DSP supported encoder list
PRODUCT_PROPERTY_OVERRIDES += \
persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Modem loging file
PRODUCT_COPY_FILES += \
    device/google/bonito/rootdir/etc/init.logging.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.$(PRODUCT_PLATFORM).logging.rc

# Dumpstate HAL
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.bonito

# Enable retrofit dynamic partitions for all bonito
# and sargo targets
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := true
PRODUCT_PACKAGES += \
    android.hardware.boot@1.0-impl.recovery \
    bootctrl.sdm710 \
    bootctrl.sdm710.recovery \
    check_dynamic_partitions \

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_product=true \
    POSTINSTALL_PATH_product=bin/check_dynamic_partitions \
    FILESYSTEM_TYPE_product=ext4 \
    POSTINSTALL_OPTIONAL_product=false \

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.use_color_management=true
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.surface_flinger.protected_contents=true

# Set thermal warm reset
PRODUCT_PRODUCT_PROPERTIES += \
    ro.thermal_warmreset = true \

# Shims
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk_platform.vendor:64 \
    android.hardware.identity-V3-ndk_platform.vendor:64 \
    android.hardware.keymaster-V3-ndk_platform.vendor:64 \
    android.hardware.power-V1-ndk_platform.vendor:64 \
    android.hardware.power.stats-V1-ndk_platform:64 \
    android.hardware.rebootescrow-V1-ndk_platform.vendor:64 \
    libgui_shim
    
# AiAi Config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/etc/allowlist_com.google.android.as.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/allowlist_com.google.android.as.xml

# EUICC permission
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.euicc.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.hardware.telephony.euicc.xml

# RCS
PRODUCT_PACKAGES += \
    PresencePolling \
    RcsService

# Enable zygote critical window.
PRODUCT_PROPERTY_OVERRIDES += \
    zygote.critical_window.minute=10

# Imported from lineageos/android_device_google_bonito 
# Squash of 990d93c...8f3e4a6

# Build necessary packages for product

# Display
PRODUCT_PACKAGES += \
    vendor.display.config@1.0

# Build necessary packages for vendor

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0.vendor \
    hardware.google.bluetooth.bt_channel_avoidance@1.0.vendor \
    hardware.google.bluetooth.sar@1.0.vendor:64 \
    vendor.qti.hardware.bluetooth_audio@2.0.vendor

# CHRE
PRODUCT_PACKAGES += \
    chre

# Codec2
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.0.vendor:32 \
    libavservices_minijail_vendor:32 \
    libcodec2_hidl@1.0.vendor:32 \
    libcodec2_vndk.vendor \
    libstagefright_bufferpool@2.0.1.vendor

# Confirmation UI
PRODUCT_PACKAGES += \
    android.hardware.confirmationui@1.0.vendor:64 \
    libteeui_hal_support.vendor:64

# Display
PRODUCT_PACKAGES += \
    vendor.display.config@1.0.vendor \
    vendor.display.config@1.1.vendor \
    vendor.display.config@1.2.vendor \
    vendor.display.config@1.3.vendor

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport.vendor \
    libhwbinder.vendor

# Identity credential
PRODUCT_PACKAGES += \
    android.hardware.identity-support-lib.vendor:64 \
    android.hardware.identity_credential.xml

# Json
PRODUCT_PACKAGES += \
    libjson

# Nos
PRODUCT_PACKAGES += \
    libnos:64 \
    libnosprotos:64 \
    libnos_client_citadel:64 \
    libnos_datagram:64 \
    libnos_datagram_citadel:64 \
    libnos_transport:64 \
    nos_app_avb:64 \
    nos_app_identity:64 \
    nos_app_keymaster:64 \
    nos_app_weaver:64

# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-vendorcompat

# Wi-Fi
PRODUCT_PACKAGES += \
    libwifi-hal:64 \
    libwifi-hal-qcom

# Misc interfaces
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor:32 \
    android.frameworks.stats@1.0.vendor:64 \
    android.hardware.authsecret@1.0.vendor:64 \
    android.hardware.biometrics.fingerprint@2.1.vendor:64 \
    android.hardware.biometrics.fingerprint@2.2.vendor:64 \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.keymaster@3.0.vendor:32 \
    android.hardware.keymaster@4.0.vendor:32 \
    android.hardware.neuralnetworks@1.0.vendor:64 \
    android.hardware.neuralnetworks@1.1.vendor:64 \
    android.hardware.neuralnetworks@1.2.vendor:64 \
    android.hardware.neuralnetworks@1.3.vendor:64 \
    android.hardware.oemlock@1.0.vendor:64 \
    android.hardware.radio.config@1.0.vendor:64 \
    android.hardware.radio.config@1.1.vendor:64 \
    android.hardware.radio.deprecated@1.0.vendor:64 \
    android.hardware.radio@1.2.vendor:64 \
    android.hardware.radio@1.3.vendor:64 \
    android.hardware.sensors@1.0.vendor:32 \
    android.hardware.sensors@2.0.vendor \
    android.hardware.weaver@1.0.vendor:64 \
    android.hardware.wifi@1.1.vendor:64 \
    android.hardware.wifi@1.2.vendor:64 \
    android.hardware.wifi@1.3.vendor:64 \
    android.hardware.wifi@1.4.vendor:64 \
    android.hardware.wifi@1.5.vendor:64 \
    android.system.net.netd@1.1.vendor:64

# Properties
TARGET_VENDOR_PROP := $(LOCAL_PATH)/vendor.prop

# Shims
PRODUCT_PACKAGES += \
    android.frameworks.stats-V1-ndk_platform.vendor:64 \
    android.hardware.identity-V3-ndk_platform.vendor:64 \
    android.hardware.keymaster-V3-ndk_platform.vendor:64 \
    android.hardware.power-V1-ndk_platform.vendor:64 \
    android.hardware.power.stats-V1-ndk_platform:64 \
    android.hardware.rebootescrow-V1-ndk_platform.vendor:64 \
    libgui_shim