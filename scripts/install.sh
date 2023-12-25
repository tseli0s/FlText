#!/usr/bin/env bash

# WARNING: Do NOT run this with the plain source code. It's supposed to be run from a
# Linux archive created from "make-releases-pkgs.sh". In fact, the script checks if
# there's an 'fltext' binary available and exits otherwise! It should only be executed
# from the said package to be installed on the host system.

readonly FLTEXT_BINARY='fltext'
readonly FLTEXT_ROOT='/usr/share/fltext'
readonly FLTEXT_ICON='data/flutter_assets/assets/logo.png'
readonly FLTEXT_DESKTOP_FILE='FlText.desktop'
readonly RED_COLOR='\033[0;31m'
readonly CYAN_COLOR='\033[1;36m'
readonly DEFAULT_COLOR='\033[0m'

function errormsg {
    printf "${RED_COLOR}Error:${DEFAULT_COLOR} $1\n"
    exit -1
}

function statusmsg {
    printf "${CYAN_COLOR}NOTE:${DEFAULT_COLOR} $1\n"
}

function check_fltext_exists {
    [[ -f "fltext" ]] || errormsg "This script must be run from a Linux archive and not arbitrarily!"
}

function check_root {
    statusmsg "Checking root access..."
    [[ $UID == 0 ]] || errormsg "This script must be run as root (UID 0), try again."
}

function copy_files {
    statusmsg "Copying files..."
    mkdir -p $FLTEXT_ROOT
    cp -r ./* $FLTEXT_ROOT
    ln -sf $FLTEXT_ROOT/$FLTEXT_BINARY /usr/bin/$FLTEXT_BINARY
    cp $FLTEXT_ICON /usr/share/icons/hicolor/512x512/apps/fltext.png
    cp ./$FLTEXT_DESKTOP_FILE /usr/share/applications/$FLTEXT_DESKTOP_FILE
}

check_root && check_fltext_exists
copy_files
statusmsg "Finished. You should now have FlText somewhere in your menu."
