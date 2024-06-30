#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Clean workspace.
rm -fr build
mkdir build
rm -fr dist
mkdir dist


# Build executable.
python3 -OO -m PyInstaller \
    --noconfirm \
    --clean \
    --specpath build \
    --workpath build \
    --distpath dist \
    --debug all \
    --noupx \
    --onefile \
    src/main.py
