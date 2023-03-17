# Android 13 for the PinePhone based on the GloDroid project

[![GloDroid](https://img.shields.io/badge/GLODROID-PROJECT-blue)](https://github.com/GloDroid/glodroid_manifest)
[![ProjectStatus](https://img.shields.io/badge/PROJECT-STATUS-yellowgreen)](https://github.com/GloDroidCommunity/pine64-pinephone/issues/2)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Discord](https://img.shields.io/discord/753603904406683670.svg?label=Discord&logo=discord&colorB=7289DA&style=flat-square)](https://discord.gg/K7YXTfJN)

## Warning!

This project is a free and open-source initiative maintained by a group of volunteers. It is provided "as is" without any warranties or guarantees.
The user is fully responsible for any issues arising from using the project.

## Flashing images

Find the archive with images [here](https://github.com/GloDroidCommunity/pine64-pinephone/releases)

Content of the archive:
* Utilities: **adb**, **fastboot**  
* Partition images: **bootloader-sd.img**, **bootloader-emmc.img**, **env.img**, **boot.img**, **boot_dtbo.img**, **super.img**  
* Recovery GPT image: **deploy-gpt.img**  
* Recovery sdcard images: **deploy-sd.img**, **deploy-sd-for-emmc.img**  
* Scripts: **flash-sd.sh**, **flash-emmc.sh**  
  
### Step 1
Using any available iso-to-usb utility, prepare recovery SDCARD.  
To flash Android on a sdcard, use *deploy-sd.img*  
To flash Android on eMMC, use *deploy-sd-for.emmc.img*  
  
### Step 2
Insert recovery sdcard into the target board.  
Connect the phone and your PC using a typec cable.  
Power up the phone.  
  
### Step 3
Ensure you have installed the adb package: ```$ sudo apt install adb``` (required to set up udev rules)  
Run .*/flash-sd.sh* utility for flashing Android to sdcard or *./flash-emmc.sh* for flashing Android to eMMC  
  
*After several minutes flashing should complete, and Android should boot*  

## Building from sources

Before building, ensure your system has at least 32GB of RAM, a swap file is at least 8GB, and 300GB of free disk space available.
We recommend using the latest laptops to get good performance. E.g., the HP ENVY x360 model15-ds1083cl takes about 5 hours to build the project.  

### Install system packages
(Ubuntu 22.04 LTS is only supported. Building on other distributions can be done using docker)
<br/>

- [Install AOSP required packages](https://source.android.com/setup/build/initializing).
```bash
sudo apt-get install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig
```

<br/>

- Install additional packages
```bash
sudo apt-get install -y swig libssl-dev flex bison device-tree-compiler mtools git gettext libncurses5 libgmp-dev libmpc-dev cpio rsync dosfstools kmod gdisk lz4 meson cmake libglib2.0-dev
```

<br/>

- Install additional packages (for building mesa3d, libcamera, and other meson-based components)
```bash
sudo apt-get install -y python3-pip pkg-config python3-dev ninja-build
sudo pip3 install mako jinja2 ply pyyaml
```

### Fetching the sources and building the project

```bash
git clone https://github.com/GloDroidCommunity/pine64-pinephone.git
cd pine64-pinephone
./unfold.sh && ./build.sh
```

Depending on your hardware and internet connection, downloading and building may take 8h or more.  
After the successful build, find the images at `./out/images.tar.gz`
