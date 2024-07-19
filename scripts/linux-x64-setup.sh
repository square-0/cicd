#!/usr/bin/env bash

# Copyright (c) 2024, Austin Brooks <ab.proxygen atSign outlook dt com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Run sanity checks.
./scripts/linux-x64-sanity.sh || exit 99


# Install Linux dependencies.
sudo apt-get update
sudo apt-get install -y \
    software-properties-common
sudo add-apt-repository -y \
    ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y \
    language-pack-en \
    language-pack-he \
    language-pack-tr \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3.12-tk \
    gettext \
    lintian
if [ ! -v GITHUB_ACTIONS ]; then
    sudo apt-get install -y \
        git \
        gh
fi


# Install Python dependencies.
# Use a venv so that only required modules
# make it into the PyInstaller executable
# to reduce file size and attack surface.
rm -fr venv

# Production environment.
${PXG_PY_CMD} -m venv venv/prod
source venv/prod/bin/activate
${PXG_PY_CMD} -m ensurepip --upgrade
${PXG_PY_CMD} -m pip install --upgrade pip
${PXG_PY_CMD} -m pip install -r src/requirements.txt

# Test environment.
${PXG_PY_CMD} -m venv venv/test
source venv/test/bin/activate
${PXG_PY_CMD} -m ensurepip --upgrade
${PXG_PY_CMD} -m pip install --upgrade pip
${PXG_PY_CMD} -m pip install -r src/requirements.txt
${PXG_PY_CMD} -m pip install \
    ruff \
    mypy


# Cleanup.
popd > /dev/null
exit 0
