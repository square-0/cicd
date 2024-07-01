#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Activate virtual environment.
source venv/bin/activate


PXG_VER=$(cat dist/Proxygen/VERSION)


# Packaging.
cp -r packaging/linux-x64/* dist/Proxygen
cp -r src dist/Proxygen


# Code documentation.
mkdir -p dist/Proxygen/docs/modules
pushd dist/Proxygen/docs/modules
shopt -s globstar
python3 -m pydoc -w ../../../../src/**/*.py
shopt -u globstar
popd


# User documentation.
mkdir -p dist/Proxygen/docs/guides
cp -r docs/* dist/Proxygen/docs/guides


# Make portable archive.
mkdir -p release
pushd dist
tar -czvf ../release/proxygen-linux-x64-$PXG_VER.tgz Proxygen
popd


# Make installer.


# Cleanup.
popd
