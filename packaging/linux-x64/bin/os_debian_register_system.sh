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
    echo ERROR: root/superuser is required to register system-wide.
    exit 99
fi


# Set working directory to the installation root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null
if [ ! -f PROXYGEN.root ]; then
    echo ERROR: Cannot find root directory.
    exit 99
fi


# Add a MIME type for "open with" association.
xdg-mime install \
    --mode system \
    etc/debian/austincbrooks-pxg.xml
update-mime-database /usr/share/mime


# Add menu item icons.
[ -d /usr/share/icons/hicolor/scalable/apps ] \
&& \
cp \
    icons/proxygen.svg \
    /usr/share/icons/hicolor/scalable/apps/austincbrooks-proxygen.svg
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
done


# Add MIME type icons.
[ -d /usr/share/icons/hicolor/scalable/mimetypes ] \
&& \
cp \
    icons/mimetype.svg \
    /usr/share/icons/hicolor/scalable/mimetypes/austincbrooks-proxygen.svg
for F in icons/mimetype-*.png; do
    [ -f "${F}" ] || continue
    PXG_ICON_RES=$(basename "${F/mimetype-/}" .png)
    xdg-icon-resource install \
        --mode system \
        --context mimetypes \
        --size "${PXG_ICON_RES}" \
        "${F}" \
        application-vnd.austincbrooks.proxygen.project \
        --noupdate
done
gtk-update-icon-cache --force /usr/share/icons/hicolor


# Add app menu item.
sed \
    --expression "s|Exec=.*|Exec=\"$(pwd)/bin/proxygen\" \"%f\"|g" \
    --follow-symlinks \
    etc/debian/austincbrooks-proxygen.desktop \
    > /tmp/austincbrooks-proxygen.desktop
xdg-desktop-menu install \
    --mode system \
    /tmp/austincbrooks-proxygen.desktop
rm /tmp/austincbrooks-proxygen.desktop || true
update-desktop-database


# Add to "PATH" as a redirection script.
cat << EOF > /usr/bin/proxygen
#!/bin/bash
"$(pwd)/bin/proxygen" "\$@"
EOF
chmod 0755 /usr/bin/proxygen


# Cleanup.
popd > /dev/null
exit 0
