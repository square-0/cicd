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


mkdir -p dist/deb/usr/share/applications
cp packaging/linux-x64/Proxygen.desktop dist/deb/usr/share/applications


# Add icons to staging directory.
mkdir -p dist/deb/usr/share/icons/hicolor/scalable/apps
cp \
    packaging/icons/proxygen.svg \
    dist/deb/usr/share/icons/hicolor/scalable/apps/proxygen.svg
for F in packaging/icons/proxygen_*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename ${F/proxygen_/} .png)
    mkdir -p dist/deb/usr/share/icons/hicolor/${PXG_ICON_RES}/apps
    cp \
        ${F} \
        dist/deb/usr/share/icons/hicolor/${PXG_ICON_RES}/apps/proxygen.png
done

# Add to "PATH" (actually a /usr/bin script).


exit 0
