#!/usr/bin/env bash

# This file sets up the necessary build files for Flatpak packages.
# In essence this means building the executable and placing it
# in the expected path.
#
# This script must be run from the ROOT FOLDER (aka. Where the "pubspec.yaml" file)

export FLT_BUILD_DIR='build/linux/x64/release/bundle'

flt_build_executable() {
    if [[ $FLT_CLEAN_FIRST == '1' ]]; then
        /usr/bin/bash scripts/clean-all.sh
    fi
    flutter build linux --release
}

flt_create_dirs() {
    [[ ! -d data/lib ]] && mkdir data/lib
    
    cp -r ${FLT_BUILD_DIR}/lib/* data/lib/
    cp -r ${FLT_BUILD_DIR}/fltext data/
    cp -r ${FLT_BUILD_DIR}/data data/data
}

flt_install_flatpak() {
    flatpak run org.flatpak.Builder \
        --force-clean \
        --sandbox \
        --user \
        --install \
        --ccache \
        --repo=repo builddir data/io.tseli0s.FlText.json
}

flt_build_executable && flt_create_dirs && flt_install_flatpak