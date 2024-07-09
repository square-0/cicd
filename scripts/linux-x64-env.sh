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


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Make any directories referenced by environment variables.
mkdir -p ~/.local/bin
mkdir -p ~/.cache/Python


# Set environment variables as GitHub runner or local dev.
if [ -v GITHUB_ACTIONS ]; then
    # Add pip's script directories to the PATH.
    echo PATH="${PATH}:${HOME}/.local/bin" >> ${GITHUB_ENV}
    # Prevent __pycache__ data from appearing in a packaged release.
    echo PYTHONPYCACHEPREFIX="${HOME}/.cache/Python" >> ${GITHUB_ENV}
    # The Python interpreter that all scripts should use.
    echo PXG_PY_CMD="python3.12" >> ${GITHUB_ENV}
else
    echo export PATH="\${PATH}:${HOME}/.local/bin" >> ~/.bashrc
    echo export PYTHONPYCACHEPREFIX="${HOME}/.cache/Python" >> ~/.bashrc
    echo export PXG_PY_CMD="python3.12" >> ~/.bashrc
    source ~/.bashrc
fi


# Cleanup.
popd > /dev/null
