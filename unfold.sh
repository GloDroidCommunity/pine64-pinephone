#!/bin/bash -ex

LOCAL_PATH=$(pwd)

echo Init repo tree using AOSP manifest
pushd aosptree
repo init -u https://android.googlesource.com/platform/manifest -b refs/tags/android-13.0.0_r35
cd .repo/manifests
mv default.xml aosp.xml
cp ${LOCAL_PATH}/manifests/glodroid.xml default.xml
git add *
git commit -m "Add GloDroid" --no-edit
popd

echo Sync repo tree
pushd aosptree
repo sync -cq
popd

echo Patch AOSP tree
patch_dir() {
    pushd aosptree/$1
    repo sync -l .
    git am ${LOCAL_PATH}/patches-aosp/$1/*
    popd
}

pushd patches-aosp
directories=$(find -name *patch | xargs dirname | uniq)
popd

for dir in ${directories}
do
    echo "Patching: $dir"
    patch_dir $dir
done

# Hack to avoid rebuilding AOSP from scratch
touch -c -t 200101010101 aosptree/external/libcxx/include/chrono

echo -e "\n\033[32m   Done   \033[0m"
