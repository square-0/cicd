#!/usr/bin/env bash

# Copyright (c) 2024, Austin Brooks <ab.proxygen@outlook.com>
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


# Sanity checks.
pushd "${PXG_ROOT}" > /dev/null
./scripts/linux-x64/sanity.sh || exit 99
set -xe


# Activate virtual environment.
source venv/test/bin/activate


# Code analysis.
ruff format \
    --line-length 120 \
    src/

ruff check \
    --no-fix \
    --no-fix-only \
    src/

mypy \
    --strict \
    --warn-unreachable \
    --no-warn-return-any \
    --pretty \
    src/


# Cleanup.
popd > /dev/null
exit 0
