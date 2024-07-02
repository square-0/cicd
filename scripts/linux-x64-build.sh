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
mkdir -p dist/exe


# Set the version number at time of build, not packaging.
echo $(date +"%y.%m.%d") > dist/exe/VERSION


# Remove linting tools so PyInstaller doesn't bundle them.
# TODO: pip uninstall black/flake8


# Build executable.
python3.12 -OO -m PyInstaller \
    --noconfirm \
    --clean \
    --specpath build \
    --workpath build \
    --distpath dist/exe \
    --noupx \
    --onefile \
    src/proxygen.py


# Cleanup.
popd
