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


# Run sanity pre-checks.
./scripts/linux-x64-precheck.sh || exit 500


# Activate virtual environment.
source venv/prod/bin/activate


# Retrieve version number from the build.
if [ ! -f dist/VERSION ]; then
    echo ERROR: No VERSION file found
    exit 500
fi
PXG_VERSION=$(cat dist/VERSION)


# Create staging directory for portable archive.
mkdir -p dist/tgz/Proxygen


# Add root directory files.
cp LICENSE.txt dist/tgz/Proxygen
cp COPYRIGHT.txt dist/tgz/Proxygen
cp README.md dist/tgz/Proxygen
cp CHANGELOG.md dist/tgz/Proxygen


# Add executables.
mkdir -p dist/tgz/Proxygen/bin
cp dist/VERSION dist/tgz/Proxygen/bin
cp dist/proxygen dist/tgz/Proxygen/bin
cp packaging/linux-x64/os_*.sh dist/tgz/Proxygen/bin


# Add locales.
find locales -iname \*.mo -print0 | \
    xargs -0 -I SRC cp --parents SRC dist/tgz/Proxygen


# Add icons.
cp -r packaging/icons dist/tgz/Proxygen


# Add source code.
cp -r src dist/tgz/Proxygen


# Add user and developer documentation.
cp -r docs dist/tgz/Proxygen


# Add auto-generated code documentation.
mkdir -p dist/tgz/Proxygen/docs/modules
pushd dist/tgz/Proxygen/docs/modules
shopt -s globstar
${PXG_PY_CMD} -m pydoc -w ../../../../../src/**/*.py
shopt -u globstar
popd


# Set file permissions.
find dist/tgz/Proxygen -type d -exec chmod 0755 {} \;
find dist/tgz/Proxygen -type f -exec chmod 0644 {} \;
chmod 0755 dist/tgz/Proxygen/bin/proxygen
chmod 0755 dist/tgz/Proxygen/bin/os_*.sh


# Make portable archive.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.tgz
pushd dist/tgz
tar --owner=0 --group=0 -czvf ../../release/${PXG_RELEASE} Proxygen
popd


# Create staging directory for deb package.
mkdir -p dist/deb


# Add files to staging directory.
mkdir -p dist/deb/usr/share/doc/proxygen
cp COPYRIGHT.txt dist/deb/usr/share/doc/proxygen/copyright
mkdir -p dist/deb/opt
cp -r dist/tgz/Proxygen dist/deb/opt
mkdir -p dist/deb/usr/share/applications
cp packaging/linux-x64/Proxygen.desktop dist/deb/usr/share/applications


# Add icons to staging directory.
mkdir -p dist/deb/usr/share/icons/hicolor/scalable/apps
cp \
    packaging/icons/proxygen.svg \
    dist/deb/usr/share/icons/hicolor/scalable/apps/proxygen.svg
for F in packaging/icons/proxygen_*.png; do
    [ -e "${F}" ] || continue
    PXG_ICON_RES=$(basename ${F/proxygen_/} .png)
    mkdir -p dist/deb/usr/share/icons/hicolor/${PXG_ICON_RES}/apps
    cp \
        ${F} \
        dist/deb/usr/share/icons/hicolor/${PXG_ICON_RES}/apps/proxygen.png
done


# Add control files for package.
mkdir -p dist/deb/DEBIAN
cp packaging/linux-x64/control dist/deb/DEBIAN
echo "Version: ${PXG_VERSION}" >> dist/deb/DEBIAN/control
PXG_DEB_KB=$(du -s dist/deb | awk '{print $1;}')
echo "Installed-Size: ${PXG_DEB_KB}" >> dist/deb/DEBIAN/control
for F in packaging/linux-x64/{pre,post}{inst,rm}; do
    [ -e "${F}" ] || continue
    cp ${F} dist/deb/DEBIAN
done


# Set file permissions.
find dist/deb -type d -exec chmod 0755 {} \;
find dist/deb -type f -exec chmod 0644 {} \;
chmod 0755 dist/deb/opt/Proxygen/bin/proxygen
chmod 0755 dist/deb/opt/Proxygen/bin/os_*.sh
for F in dist/deb/DEBIAN/{pre,post}{inst,rm}; do
    [ -e "${F}" ] || continue
    chmod 0755 ${F}
done


# Make deb package.
# TODO: lintian on Ubuntu 20.04 doesn't recognize:
# -X files/hierarchy/standard
# Add it when upgrading to Ubuntu 22.04.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.deb
dpkg-deb --root-owner-group --build dist/deb release/${PXG_RELEASE}
lintian \
    --info \
    -X debian/changelog \
    release/${PXG_RELEASE}


# Generate checksums.
pushd release
for F in *.tgz *.deb; do
    [ -e "${F}" ] || continue
    sha256sum --binary ${F} > ${F}.sha256
done
popd


# Cleanup.
popd > /dev/null
