#!/usr/bin/env bash

# This script is used to create an APK and a Linux archive,
# to be distributed each release.
# TODO: Use this on GitHub Actions, by making automated releases each build.

RED_COLOR='\033[0;31m'
CYAN_COLOR='\033[1;36m'
DEFAULT_COLOR='\033[0m'

readonly MAJOR=0
readonly MINOR=1
readonly PATCH=0

function errormsg {
    printf "${RED_COLOR}Error:${DEFAULT_COLOR} $1\n"
    exit -1
}

function statusmsg {
    printf "${CYAN_COLOR}NOTE:${DEFAULT_COLOR} $1\n"
}

function flt_cleanup {
    statusmsg "Cleaning up previous build artifacts under 'pkg/'"...
    rm -rfv pkg/
}

function flt_build {
    statusmsg "Starting build of APK (Android package)..."
    flutter build apk --release || errormsg "Couldn't build APK, stopping here."
    statusmsg "Starting build of Linux binary (As a bundle)"
    flutter build linux --release || errormsg "Couldn't build Linux package, stopping here"
}

function flt_package {
    statusmsg "Creating build directories..."
    [[ -d pkg ]] || mkdir pkg
    [[ -d pkg/linux ]] || mkdir pkg/linux

    statusmsg "Moving files to new directories..."
    mv build/app/outputs/flutter-apk/app-release.apk pkg/FlText-$MAJOR.$MINOR.$PATCH-all.apk
    mv build/linux/x64/release/bundle pkg/linux
    cp scripts/install.sh pkg/linux/bundle
    cp data/FlText.desktop pkg/linux/bundle

    statusmsg "Creating Linux archive (Using tar)..."
    cd pkg/linux/
    XZ_OPT='-9' tar -cvJf fltext-$MAJOR.$MINOR.$PATCH-linux-amd64.tar.xz bundle/

    statusmsg "Packaging finished, cleaning up..."
    cp fltext-$MAJOR.$MINOR.$PATCH-linux-amd64.tar.xz ../
}

flt_cleanup && flt_build && flt_package