#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Activate virtual environment.
source venv/bin/activate


# Clean the build environment.
mkdir -p build
mkdir -p dist
find build -mindepth 1 -delete
find dist -mindepth 1 -delete
mkdir -p dist/Proxygen


# Set the version number.
echo $(date +"%y.%m.%d") > dist/Proxygen/VERSION


# Build executable.
python3 -OO -m PyInstaller \
    --noconfirm \
    --clean \
    --specpath build \
    --workpath build \
    --distpath dist/Proxygen \
    --noupx \
    --onefile \
    src/proxygen.py


# Cleanup.
popd
