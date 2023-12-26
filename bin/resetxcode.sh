#!/bin/bash

# place this shell script to
# ./
# ├── bin/
# │   └── ibdesignable-workaround.sh
# └── YourGreatApp.xcodeproj

set -euo pipefail

if [ "$(uname -m)" != 'arm64' ]; then
    echo '[INFO] This workaround script is M1 Mac Only.'
    exit
fi

SRCROOT=$(cd "$(dirname "$0")/../" || exit 1; pwd)
echo "SRCROOT: ${SRCROOT}"
cd "${SRCROOT}" || exit 1

# get 'YourGreatApp' string from './YourGreatApp.xcodeproj'
PROJECT_NAME=$(find . -maxdepth 1 -name '*.xcodeproj' | cut -d '/' -f2 | cut -d '.' -f1)
PROJECT="${PROJECT_NAME}"
echo "PROJECT: ${PROJECT}"
echo "PROJECT_NAME: ${PROJECT_NAME}"

# find /${PROJECT_NAME}-[a-z]{28}/ named directory from default DerivedData
cd "${HOME}/Library/Developer/Xcode/DerivedData" || exit 1
BUILD_DIR="$(find . -maxdepth 1 -type d -regex "\./${PROJECT_NAME}-[a-z]\{28\}")"
cd "${BUILD_DIR}/Build/Products" || exit 1
BUILD_DIR=$(pwd)
BUILD_ROOT="${BUILD_DIR}"
echo "BUILD_DIR: ${BUILD_DIR}"
echo "BUILD_ROOT: ${BUILD_ROOT}"

# workaround
find . -maxdepth 1 -name '*-iphonesimulator' -print0 | while read -r -d '' file; do
    echo "[info] rm -rf '${file/-iphonesimulator/-iphoneos}'"
    rm -rf "${file/-iphonesimulator/-iphoneos}"
    echo "[INFO] cp -r '${file}' '${file/-iphonesimulator/-iphoneos}'"
    cp -r "${file}" "${file/-iphonesimulator/-iphoneos}"
done

echo '[INFO] Done! restart your Xcode'
