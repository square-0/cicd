#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Create build directories.
mkdir -p build
mkdir -p dist


# Build executable.
python3 -OO -m PyInstaller \
    --noconfirm \
    --clean \
    --specpath build \
    --workpath build \
    --distpath dist \
    --noupx \
    --onefile \
    src/main.py
