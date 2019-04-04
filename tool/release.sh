#!/bin/bash

TOOL_DIR="`pwd`"

# 1. package name
# 2. lts release
create_package() {
    if [[ "$2" == "yes" ]]; then
        local PACKAGE_NAME="flutter_ffmpeg_$1_lts"
    else
        local PACKAGE_NAME="flutter_ffmpeg_$1"
    fi

    local PACKAGE_PATH="${TOOL_DIR}/../packages/${PACKAGE_NAME}"

    if [[ -d ${PACKAGE_PATH} ]]; then
        echo "error: package ${PACKAGE_NAME} exists"
        exit 1
    fi

    mkdir -p ${PACKAGE_PATH}

    # 1. COPY ANDROID
    mkdir -p ${PACKAGE_PATH}/android
    cp -r ${TOOL_DIR}/../android/src ${PACKAGE_PATH}/android
    cp ${TOOL_DIR}/../android/.gitignore ${PACKAGE_PATH}/android
    cp ${TOOL_DIR}/../android/build.gradle ${PACKAGE_PATH}/android
    cp ${TOOL_DIR}/../android/gradle.properties ${PACKAGE_PATH}/android
    cp ${TOOL_DIR}/../android/settings.gradle ${PACKAGE_PATH}/android

    # 2. COPY IOS
    cp -r ${TOOL_DIR}/../ios ${PACKAGE_PATH}

    # 3. COPY lib
    cp -r ${TOOL_DIR}/../lib ${PACKAGE_PATH}

    # 4. COPY
    cp ${TOOL_DIR}/../.gitignore ${PACKAGE_PATH}
    cp ${TOOL_DIR}/../.metadata ${PACKAGE_PATH}
    cp ${TOOL_DIR}/../pubspec.yaml ${PACKAGE_PATH}

    # 5. COPY LICENSE
    if [[ $1 == *gpl ]]; then
        cp ${TOOL_DIR}/../LICENSE.GPLv3 ${PACKAGE_PATH}/LICENSE
    else
        cp ${TOOL_DIR}/../LICENSE ${PACKAGE_PATH}/LICENSE
    fi

    # 6. UPDATE DEPENDENCIES
    sed -i .tmp "s/mobile-ffmpeg-https/mobile-ffmpeg-$1/g" ${PACKAGE_PATH}/android/build.gradle
    sed -i .tmp "s/mobile-ffmpeg-https/mobile-ffmpeg-$1/g" ${PACKAGE_PATH}/ios/flutter_ffmpeg.podspec
    
    if [[ "$2" == "yes" ]]; then
        sed -i .tmp "s/minSdkVersion 24/minSdkVersion 21/g" ${PACKAGE_PATH}/android/build.gradle
        sed -i .tmp "s/implementation \'com.arthenica:mobile-ffmpeg-$1:$VERSION\'/implementation \'com.arthenica:mobile-ffmpeg-$1:$LTS_VERSION\'/g" ${PACKAGE_PATH}/android/build.gradle
        sed -i .tmp "s/mobile-ffmpeg-$1\'\, \'$VERSION/mobile-ffmpeg-$1\'\, \'$LTS_VERSION/g" ${PACKAGE_PATH}/ios/flutter_ffmpeg.podspec
    fi
    
    # 8. CLEAN TEMP FILES
    rm -f ${PACKAGE_PATH}/ios/flutter_ffmpeg.podspec.tmp
    rm -f ${PACKAGE_PATH}/android/build.gradle.tmp
}

if [[ $# -ne 2 ]];
then
    echo "Usage: release.sh <version> <lts version>"
    exit 1
fi

VERSION=$1
LTS_VERSION=$2

echo -e "Creating release packages for version: $VERSION and lts version: $LTS_VERSION\n"

# MAIN RELEASES
create_package "min"
create_package "min-gpl"
create_package "https"
create_package "https-gpl"
create_package "audio"
create_package "video"
create_package "full"
create_package "full-gpl"

# LTS RELEASES
create_package "min" "yes"
create_package "min-gpl" "yes"
create_package "https" "yes"
create_package "https-gpl" "yes"
create_package "audio" "yes"
create_package "video" "yes"
create_package "full" "yes"
create_package "full-gpl" "yes"