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


# Scan all source code for FIXME comments.
grep \
    --ignore-case \
    --include \*.py \
    --include \*.sh \
    --exclude "$(basename "$0")" \
    --line-number \
    --recursive \
    "FIXME" \
    src \
    scripts \
&& (
    echo ERROR: Found FIXME comments in source code.
    exit 99
)


# Cleanup.
popd > /dev/null
exit 0
