#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Activate virtual environment.
source venv/bin/activate


# Retrieve version number from the build.
PXG_VERSION=$(cat dist/exe/VERSION)


# Create staging directory for portable archive.
mkdir -p dist/Proxygen


# Add root directory files.
cp LICENSE.txt dist/Proxygen
cp README.md dist/Proxygen
cp CHANGELOG.md dist/Proxygen


# Add executables.
mkdir -p dist/Proxygen/bin
cp -r dist/exe/* dist/Proxygen/bin
cp packaging/linux-x64/open_with.sh dist/Proxygen/bin


# Add source code.
cp -r src dist/Proxygen


# Add user and developer documentation.
cp -r docs dist/Proxygen


# Add auto-generated code documentation.
mkdir -p dist/Proxygen/docs/modules
pushd dist/Proxygen/docs/modules
shopt -s globstar
python3.12 -m pydoc -w ../../../../src/**/*.py
shopt -u globstar
popd


# Set file permissions.
find dist/Proxygen -type d -exec chmod 0755 {} \;
find dist/Proxygen -type f -exec chmod 0644 {} \;
chmod 0755 dist/Proxygen/bin/proxygen
chmod 0755 dist/Proxygen/bin/open_with.sh


# Make portable archive.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.tgz
pushd dist
tar --owner=0 --group=0 -czf ../release/${PXG_RELEASE} Proxygen
popd


# Create staging directory for .deb package.
mkdir -p dist/deb


# Add files to staging directory.
mkdir -p dist/deb/opt
cp -r dist/Proxygen dist/deb/opt
mkdir -p dist/deb/usr/share/applications
cp packaging/linux-x64/Proxygen.desktop dist/deb/usr/share/applications
mkdir -p dist/deb/usr/share/icons/hicolor/64x64/apps
cp packaging/icons/proxygen_icon_64x64.png dist/deb/usr/share/icons/hicolor/64x64/apps/proxygen.png


# Build package's control file.
mkdir -p dist/deb/DEBIAN
cp packaging/linux-x64/control dist/deb/DEBIAN
echo "Version: ${PXG_VERSION}" >> dist/deb/DEBIAN/control
PXG_DEB_KB=$(du -s dist/deb | awk '{print $1;}')
echo "Installed-Size: ${PXG_DEB_KB}" >> dist/deb/DEBIAN/control


# Set file permissions.
find dist/deb -type d -exec chmod 0755 {} \;
find dist/deb -type f -exec chmod 0644 {} \;
chmod 0755 dist/deb/opt/Proxygen/bin/proxygen
chmod 0755 dist/deb/opt/Proxygen/bin/open_with.sh
chmod 0755 dist/deb/DEBIAN/{pre,post}{inst,rm} || true


# Make .deb package.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.deb
dpkg-deb --root-owner-group --build dist/deb release/${PXG_RELEASE}
lintian release/${PXG_RELEASE} --info


# Generate checksums.
pushd release
for F in *; do
    sha256sum --binary \
        ${F} > \
        ${F}.sha256
done
popd


# Cleanup.
popd
