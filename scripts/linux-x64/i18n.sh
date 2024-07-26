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
set -e


# Retrieve version number from the build.
if [ ! -f dist/VERSION ]; then
    echo ERROR: No VERSION file found.
    exit 99
fi
PXG_VERSION=$(cat dist/VERSION)


# Create list of files to scan for translation.
# xgettext can't scan subdirectories on its own.
mkdir -p build
find src -name \*.py > build/pofiles.lst


# Extract strings for translation into a fresh template.
# Manual page describing how the keyword argument works: 
# https://www.gnu.org/software/gettext/manual/html_node/xgettext-Invocation.html#Language-specific-options
xgettext \
    --package-name Proxygen \
    --package-version "${PXG_VERSION}" \
    --copyright-holder "Austin Brooks <ab.proxygen@outlook.com>" \
    --msgid-bugs-address "Austin Brooks <ab.proxygen@outlook.com>" \
    --default-domain proxygen \
    --output locales/proxygen.pot \
    --width 72 \
    --language Python \
    --keyword \
    --keyword=msg1 \
    --keyword=msgN:1,2 \
    --force-po \
    --files-from build/pofiles.lst
rm build/pofiles.lst


# Remove the American English catalog.
rm locales/en_US/LC_MESSAGES/proxygen.po || true


# Merge new strings into existing .po files.
find locales -name proxygen.po -exec \
    sh -c \
    'msgmerge \
    "$0" \
    locales/proxygen.pot \
    --width 72 \
    --update \
    --force-po \
    --backup none' \
    '{}' \;


# Clone the American English catalog from the template.
mkdir -p locales/en_US/LC_MESSAGES
msgen \
    locales/proxygen.pot \
    --output-file locales/en_US/LC_MESSAGES/proxygen.po \
    --width 72 \
    --force-po


# On known entries, change the translation to something new
# so that a unit test can verify the translation is loading.
pushd locales/en_US/LC_MESSAGES
if [ ! -f header.txt ]; then
    echo ERROR: Missing header.txt for American English .po file.
    exit 99
fi
sed \
    --expression '1,19d' \
    --follow-symlinks \
    --in-place \
    proxygen.po
cat \
    header.txt \
    proxygen.po \
    > proxygen.tmp
sed \
    --expression 's/msgstr "l10n unit test 1"/msgstr "l10n unit test message"/' \
    --expression 's/msgstr\[0] "l10n unit test 2"/msgstr[0] "l10n unit test singular"/' \
    --expression 's/msgstr\[1] "l10n unit test 2"/msgstr[1] "l10n unit test plural"/' \
    --follow-symlinks \
    --in-place \
    proxygen.tmp
mv proxygen.tmp proxygen.po
popd


# Cleanup.
popd > /dev/null
exit 0
