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


# Activate virtual environment.
source venv/prod/bin/activate


# Clean the build environment.
mkdir -p build
mkdir -p dist
find build -mindepth 1 -delete
find dist -mindepth 1 -delete


# Set the version number to the build date, not packaging date.
echo $(date --utc "+%Y.%m.%d") > dist/VERSION


# Build executable.
"${PXG_PY_CMD}" -OO -m PyInstaller \
    --clean \
    --noconfirm \
    --specpath build \
    --workpath build \
    --distpath dist \
    --noupx \
    --onefile \
    src/proxygen.py \
    || exit 99


# Cleanup.
popd > /dev/null
exit 0
