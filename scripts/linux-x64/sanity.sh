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


# All scripts should start in Proxygen's root directory.
if [ ! -f PROXYGEN.root ]; then
    echo ERROR: Cannot find root directory.
    exit 99
fi


# Verify that all expected environment variables are set.
[[ "${PXG_ROOT}" ]] && \
[[ "${PXG_PY_CMD}" ]] \
|| (
    echo ERROR: A core environment variable was not set.
    echo Did scripts/platform/env run?
    exit 99
)


# Success.
exit 0
