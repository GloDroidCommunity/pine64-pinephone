/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <array>

#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/types.h>

#include <aidl/android/hardware/light/BnLights.h>
#include <android-base/logging.h>
#include <android/binder_manager.h>
#include <android/binder_process.h>

using ::aidl::android::hardware::light::BnLights;
using ::aidl::android::hardware::light::HwLight;
using ::aidl::android::hardware::light::HwLightState;
using ::aidl::android::hardware::light::ILights;
using ::aidl::android::hardware::light::LightType;
using ::ndk::ScopedAStatus;
using ::ndk::SharedRefBase;

static pthread_once_t g_init = PTHREAD_ONCE_INIT;
static pthread_mutex_t g_lock = PTHREAD_MUTEX_INITIALIZER;

struct LightAddress {
    uint8_t red;
    uint8_t green;
    uint8_t blue;
};

char const* const RED_LED_FILE = "/sys/class/leds/red:indicator/brightness";

char const* const BLUE_LED_FILE = "/sys/class/leds/blue:indicator/brightness";

char const* const GREEN_LED_FILE = "/sys/class/leds/green:indicator/brightness";

char const* const LCD_FILE = "/sys/class/backlight/backlight/brightness";

static char const* const MAX_BRIGHTNESS_FILE = "/sys/class/backlight/backlight/max_brightness";

static int SYS_MAX_BRIGHTNESS = 0;        // Max brightness readed form system

static int sys_write_int(int fd, int value) {
    char buffer[16];
    size_t bytes;
    ssize_t amount;

    bytes = snprintf(buffer, sizeof(buffer), "%d\n", value);
    if (bytes >= sizeof(buffer)) return -EINVAL;
    amount = write(fd, buffer, bytes);
    return amount == -1 ? -errno : 0;
}

static int sysfs_read_int(const char* name, int& value) {
    uint8_t const BUFFER_SIZE = 16;
    char buffer[BUFFER_SIZE] = {0};
    ssize_t amount = -EINVAL;
    int fd = open(name, O_RDONLY);
    if (fd < 0) {
        LOG(ERROR) << "COULD NOT OPEN LED_DEVICE" << name;
        return amount;
    }
    do {
        amount = read(fd, (void *)buffer, BUFFER_SIZE);
        if (-EINVAL == amount) {
            break;
        }
        value = atoi(buffer);
    } while (false);
    close(fd);
    return amount;
}

class Lights : public BnLights {
  private:
    std::vector<HwLight> availableLights;

    void addLight(LightType const type, int const ordinal) {
        HwLight light{};
        light.id = availableLights.size();
        light.type = type;
        light.ordinal = ordinal;
        availableLights.emplace_back(light);
    }

    int rgbToBrightness(int color) {
        int const r = ((color >> 16) & 0xFF) * 77 / 255;
        int const g = ((color >> 8) & 0xFF) * 150 / 255;
        int const b = (color & 0xFF) * 29 / 255;
        return (r << 16) | (g << 8) | b;
    }

    void writeLed(const char* path, int color) {
        int fd = open(path, O_WRONLY);
        if (fd < 0) {
            LOG(ERROR) << "COULD NOT OPEN LED_DEVICE " << path;
            return;
        }

        sys_write_int(fd, color);
        close(fd);
    }

    int convertBrightness(int current_brightness) {
        uint32_t const MAX_BRIGHTNESS = 0xFF;   // Max brightness recived from api
        uint32_t const MIN_BRIGHTNESS = 0x00;
        const int max_shift = MAX_BRIGHTNESS - MIN_BRIGHTNESS;
        int recived_brughtness_shift = max_shift - (MAX_BRIGHTNESS - (current_brightness & 0xFF));
        int recived_brightness_persent = (recived_brughtness_shift * 100) / max_shift;
        int calculated = (SYS_MAX_BRIGHTNESS * recived_brightness_persent) / 100;
        return calculated > SYS_MAX_BRIGHTNESS ? SYS_MAX_BRIGHTNESS : calculated;
    }

  public:
    Lights() : BnLights() {
        pthread_mutex_init(&g_lock, NULL);

        addLight(LightType::BACKLIGHT, 0);
        addLight(LightType::KEYBOARD, 0);
        addLight(LightType::BUTTONS, 0);
        addLight(LightType::BATTERY, 0);
        addLight(LightType::NOTIFICATIONS, 0);
        addLight(LightType::ATTENTION, 0);
        addLight(LightType::BLUETOOTH, 0);
        addLight(LightType::WIFI, 0);
    }

    ScopedAStatus setLightState(int id, const HwLightState& state) override {
        if (!(0 <= id && id < availableLights.size())) {
            LOG(ERROR) << "Light id " << (int32_t)id << " does not exist.";
            return ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
        }

        int const color = rgbToBrightness(state.color);
        HwLight const& light = availableLights[id];

        int ret = 0;

        switch (light.type) {
            case LightType::BATTERY:
                writeLed(RED_LED_FILE, ((state.color >> 16) & 0xff) > 128 ? 1 : 0);
                writeLed(GREEN_LED_FILE, ((state.color >> 8) & 0xff) > 128 ? 1 : 0);
                break;
            case LightType::ATTENTION:
            case LightType::NOTIFICATIONS:
                writeLed(BLUE_LED_FILE, color ? 1 : 0);
                break;
            case LightType::BACKLIGHT:
                writeLed(LCD_FILE, convertBrightness(state.color));
                break;
        }

        if (ret == 0) {
            return ScopedAStatus::ok();
        } else {
            return ScopedAStatus::fromServiceSpecificError(ret);
        }
    }

    ScopedAStatus getLights(std::vector<HwLight>* lights) override {
        for (auto i = availableLights.begin(); i != availableLights.end(); i++) {
            lights->push_back(*i);
        }
        return ScopedAStatus::ok();
    }
};

int main() {
    ABinderProcess_setThreadPoolMaxThreadCount(0);

    std::shared_ptr<Lights> light = SharedRefBase::make<Lights>();

    const std::string instance = std::string() + ILights::descriptor + "/default";
    binder_status_t status = AServiceManager_addService(light->asBinder().get(), instance.c_str());

    if (status != STATUS_OK) {
        LOG(ERROR) << "Could not register" << instance;
        // should abort, but don't want crash loop for local testing
    }
    if (-EINVAL == sysfs_read_int(MAX_BRIGHTNESS_FILE, SYS_MAX_BRIGHTNESS)) {
        LOG(ERROR) << "COULD NOT OPEN LED_DEVICE" << MAX_BRIGHTNESS_FILE;
    }
    ABinderProcess_joinThreadPool();

    return 1;  // should not reach
}
