#!/bin/bash

# This script is used to update the LineageOS manifest file

echo "You are going to update the LineageOS manifest file."
echo "During the update, the current AOSP work directory (aosptree/) will be updated."
echo "If you have any local changes, they will be lost."
echo "Do you want to continue? [y/N]"
read -r answer
if [[ ! $answer =~ ^[Yy]$ ]]
then
    echo "Aborting"
    exit 1
fi

echo Init repo tree using LineageOS manifest
pushd ../aosptree
repo init -u https://github.com/LineageOS/android.git -b refs/heads/lineage-21.0
repo sync -c
repo manifest -r -o ../manifests/lineage-static.xml
popd

# Add the warning line at the beginning of the manifest
sed -i '2i\\n<!-- Autogenerated. Please do not edit. Run update_lineage_manifest.sh to update. -->\n' lineage-static.xml

# Rename all "github" to "github_los" in the manifest
sed -i 's/"github"/"github_los"/g' lineage-static.xml

# Rename fetch=".." to fetch="https://github.com/"
sed -i 's/fetch=".."/fetch="https:\/\/github.com\/"/g' lineage-static.xml

echo -e "\n\033[32m   Done   \033[0m"
