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
cp COPYRIGHT.txt dist/Proxygen
cp README.md dist/Proxygen
cp CHANGELOG.md dist/Proxygen


# Add executables.
mkdir -p dist/Proxygen/bin
cp -r dist/exe/* dist/Proxygen/bin
cp packaging/linux-x64/integrate.sh dist/Proxygen/bin


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
chmod 0755 dist/Proxygen/bin/integrate.sh


# Make portable archive.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.tgz
pushd dist
tar --owner=0 --group=0 -czf ../release/${PXG_RELEASE} Proxygen
popd


# Create staging directory for deb package.
mkdir -p dist/deb


# Add files to staging directory.
mkdir -p dist/deb/usr/share/doc/proxygen
cp COPYRIGHT.txt dist/deb/usr/share/doc/proxygen/copyright
mkdir -p dist/deb/opt
cp -r dist/Proxygen dist/deb/opt
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
chmod 0755 dist/deb/opt/Proxygen/bin/integrate.sh
for F in dist/deb/DEBIAN/{pre,post}{inst,rm}; do
    [ -e "${F}" ] || continue
    chmod 0755 ${F}
done


# Make deb package.
mkdir -p release
PXG_RELEASE=proxygen-linux-x64-${PXG_VERSION//./}.deb
dpkg-deb --root-owner-group --build dist/deb release/${PXG_RELEASE}
lintian \
    --info \
    -X files/hierarchy/standard,debian/changelog \
    release/${PXG_RELEASE}


# Generate checksums.
pushd release
for F in *.tgz *.deb; do
    [ -e "${F}" ] || continue
    sha256sum --binary ${F} > ${F}.sha256
done
popd


# Cleanup.
popd
