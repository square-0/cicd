#!/bin/bash

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


# NOTE: The portable archive version could be "installed" anywhere.
#       Make sure all paths are relative to this script's location.


# Exit if not running as root/superuser.
if (($EUID)); then
    echo ERROR: root/superuser is required to unregister system-wide.
    exit 99
fi


# Set working directory to the installation root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null
[ -f LICENSE.txt ] || exit 99


# Remove system icons.
[ -f /usr/share/icons/hicolor/scalable/apps/austincbrooks-proxygen.svg ] \
    && rm /usr/share/icons/hicolor/scalable/apps/austincbrooks-proxygen.svg
[ -f /usr/share/icons/hicolor/scalable/mimetypes/austincbrooks-proxygen.svg ] \
    && rm /usr/share/icons/hicolor/scalable/mimetypes/austincbrooks-proxygen.svg
for F in icons/proxygen-*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename "${F/proxygen-/}" .png)
    xdg-icon-resource uninstall \
        --mode system \
        --context apps \
        --size "${PXG_ICON_RES}" \
        austincbrooks-proxygen \
        --noupdate
    xdg-icon-resource uninstall \
        --mode system \
        --context mimetypes \
        --size "${PXG_ICON_RES}" \
        application-vnd.austincbrooks.proxygen.project \
        --noupdate
done
gtk-update-icon-cache --force /usr/share/icons/hicolor


# Remove "open with" association.
xdg-mime uninstall \
    --mode system \
    etc/debian/austincbrooks-pxg.xml
update-mime-database /usr/share/mime


# Remove app menu item.
xdg-desktop-menu uninstall \
    --mode system \
    etc/debian/austincbrooks-proxygen.desktop
update-desktop-database


# Remove "PATH" redirection script.
[ -f /usr/bin/proxygen ] \
    && rm -f /usr/bin/proxygen


# Cleanup.
popd > /dev/null
exit 0
