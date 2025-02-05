#!/bin/bash -e

trap 'echo -e "\nbuild.sh interrupted"; exit 1' SIGINT

echo Building the Android
pushd aosptree
. build/envsetup.sh
lunch pine64_pinephone-ap3a-userdebug
make images -k || make images -j1
make sdcard
popd
