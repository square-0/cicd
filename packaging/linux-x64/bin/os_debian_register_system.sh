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


# NOTE: This script expects to run as root/superuser.
# NOTE: The portable archive version could be "installed" anywhere.
#       Make sure all paths are relative to this script's location.


# Set working directory to the installation root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null
[ -f LICENSE.txt ] || exit 99


# Add system icons.
[ -d /usr/share/icons/hicolor/scalable/apps ] \
    && \
    cp \
        icons/proxygen.svg \
        /usr/share/icons/hicolor/scalable/apps/proxygen.svg
[ -d /usr/share/icons/hicolor/scalable/mimetypes ] \
    && \
    cp \
        icons/proxygen.svg \
        /usr/share/icons/hicolor/scalable/mimetypes/proxygen.svg
for F in icons/proxygen-*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename "${F/proxygen-/}" .png)
    xdg-icon-resource install \
        --mode system \
        --context apps \
        --size "${PXG_ICON_RES}" \
        "${F}" \
        austincbrooks-proxygen \
        --noupdate
    xdg-icon-resource install \
        --mode system \
        --context mimetypes \
        --size "${PXG_ICON_RES}" \
        "${F}" \
        application-vnd.austincbrooks.proxygen.project \
        --noupdate
done
gtk-update-icon-cache --force /usr/share/icons/hicolor


# Make an "open with" association.
xdg-mime install \
    --mode system \
    etc/austincbrooks-pxg.xml
update-mime-database /usr/share/mime


# Add app menu item.
xdg-desktop-menu install \
    --mode system \
    etc/austincbrooks-proxygen.desktop
update-desktop-database


# Add to "PATH" as a /usr/bin script.
cat << EOF > /usr/bin/proxygen
#!/usr/bin/env bash
$(pwd)/bin/proxygen \$@
EOF
chmod 0755 /usr/bin/proxygen


# Cleanup.
popd > /dev/null
exit 0

