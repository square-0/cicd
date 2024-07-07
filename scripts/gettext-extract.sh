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


# Retrieve version number from the build.
if [ ! -f dist/VERSION ]; then
    exit 1
fi
PXG_VERSION=$(cat dist/VERSION)


# Extract strings for translation into a fresh template.
# Manual page describing how the keyword argument works: 
# https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/xgettext-Invocation.html#Language-specific-options
xgettext \
    --package-name Proxygen \
    --package-version ${PXG_VERSION} \
    --copyright-holder "Austin Brooks <ab.proxygen@outlook.com>" \
    --msgid-bugs-address "Austin Brooks <ab.proxygen@outlook.com>" \
    --default-domain proxygen \
    --output locales/proxygen.pot \
    --width 72 \
    --language Python \
    --keyword \
    --keyword=i18n_msg \
    --keyword=i18n_msgN:1,2 \
    src/*.py


# Merge new strings into existing .po files.
find locales -name proxygen.po -exec \
    msgmerge \
    {} \
    locales/proxygen.pot \
    --width 72 \
    --update \
    --backup none \;


# Cleanup.
popd
