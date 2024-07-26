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
if (( $EUID != 0 )); then
    echo ERROR: root/superuser is required to unregister system-wide.
    exit 99
fi


# Set working directory to the installation root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null
if [ ! -f PROXYGEN.root ]; then
    echo ERROR: Cannot find root directory.
    exit 99
fi


# Remove app menu item.
sed \
    --expression "s|Exec=.*|Exec=\"$(pwd)/bin/proxygen\" \"%f\"|g" \
    --follow-symlinks \
    etc/debian/austincbrooks-proxygen.desktop \
    > /tmp/austincbrooks-proxygen.desktop
xdg-desktop-menu uninstall \
    --mode system \
    /tmp/austincbrooks-proxygen.desktop
rm /tmp/austincbrooks-proxygen.desktop || true
update-desktop-database


# Remove menu item icons.
rm /usr/share/icons/hicolor/scalable/apps/austincbrooks-proxygen.svg || true
for F in icons/proxygen-*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename "${F/proxygen-/}" .png)
    xdg-icon-resource uninstall \
        --mode system \
        --context apps \
        --size "${PXG_ICON_RES}" \
        austincbrooks-proxygen \
        --noupdate
done


# Remove MIME type icons.
rm /usr/share/icons/hicolor/scalable/mimetypes/austincbrooks-proxygen.svg || true
for F in icons/mimetype-*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename "${F/mimetype-/}" .png)
    xdg-icon-resource uninstall \
        --mode system \
        --context mimetypes \
        --size "${PXG_ICON_RES}" \
        application-vnd.austincbrooks.proxygen.project \
        --noupdate
done
gtk-update-icon-cache --force /usr/share/icons/hicolor


# Remove MIME type for "open with" association.
xdg-mime uninstall \
    --mode system \
    etc/debian/austincbrooks-pxg.xml
update-mime-database /usr/share/mime


# Remove "PATH" redirection script.
rm -f /usr/bin/proxygen || true


# Cleanup.
popd > /dev/null
exit 0
