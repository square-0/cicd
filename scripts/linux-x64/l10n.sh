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


# Show unit test translations for verification.
echo INFO: Unit test translations...
echo If none, did scripts/platform/i18n run first?
grep "l10n unit test" locales/en_US/LC_MESSAGES/proxygen.po


# Compile .po files into .mo files.
find locales -name \*.po -execdir \
    sh -c \
    'msgfmt \
    "$0" \
    --output-file "$(basename "$0" .po).mo"' \
    '{}' \;


# List the .mo files that were compiled.
echo INFO: Compiled .mo files...
find locales -name \*.mo -print


# Cleanup.
popd > /dev/null
exit 0
