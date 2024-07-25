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


# Run sanity checks.
./scripts/linux-x64-sanity.sh || exit 99
set -x # TODO: -e


# Install FFmpeg dependencies.
# See: https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
sudo apt-get install -y \
    autoconf \
    automake \
    build-essential \
    cmake \
    gnutls-dev \
    libtool \
    libunistring-dev \
    meson \
    ninja-build \
    pkg-config \
    texinfo \
    yasm \
    zlib1g-dev
if [[ -z "${GITHUB_ACTIONS}" ]]; then
    sudo apt-get install -y \
        subversion
fi


# Create/clean the build environment.
rm -fr "${PXG_BUILD}" || true
mkdir -p "${PXG_SOURCE}"
mkdir -p "${PXG_BUILD}/lib/pkgconfig"
mkdir -p "${PXG_DIST}"
mkdir -p "${PXG_RELEASE}"


### GET SOURCE CODE


# nasm
pushd "${PXG_SOURCE}"
rm -fr nasm || true
git clone https://github.com/netwide-assembler/nasm \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
# The "install:" block of the makefile tries to
# install man pages that are not built by default.
# "make install" fails with file not found errors.
# Option 1 is to "apt-get install asciidoc" and
# "make manpages" before "make install". But
# asciidoc is 1 GB of dependencies, and those
# generated man pages will never be used.
# Option 2 is to remove references to the man
# pages from the makefile's "install:" block.
# See: https://bugzilla.nasm.us/show_bug.cgi?id=3392557
cd nasm
sed \
    --expression '/$(mandir)/d' \
    --follow-symlinks \
    --in-place \
    Makefile.in \
    || true
git diff > PROXYGEN-SOURCE-MODS.diff
popd


# lame
pushd "${PXG_SOURCE}"
rm -fr lame || true
svn checkout https://svn.code.sf.net/p/lame/svn/trunk/lame \
    --quiet
cd lame
svn diff > PROXYGEN-SOURCE-MODS.diff
popd


# opus
pushd "${PXG_SOURCE}"
rm -fr opus || true
git clone https://gitlab.xiph.org/xiph/opus \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
cd opus
git diff > PROXYGEN-SOURCE-MODS.diff
popd


# SVT-AV1
pushd "${PXG_SOURCE}"
rm -fr SVT-AV1 || true
git clone https://gitlab.com/AOMediaCodec/SVT-AV1 \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
cd SVT-AV1
git diff > PROXYGEN-SOURCE-MODS.diff
popd


# zimg
pushd "${PXG_SOURCE}"
rm -fr zimg || true
git clone https://github.com/sekrit-twc/zimg \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
cd zimg
git diff > PROXYGEN-SOURCE-MODS.diff
popd


# ffmpeg
pushd "${PXG_SOURCE}"
rm -fr ffmpeg || true
git clone https://github.com/ffmpeg/ffmpeg \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
cd ffmpeg
git diff > PROXYGEN-SOURCE-MODS.diff
popd


# Proxygen
pushd "${PXG_SOURCE}"
rm -fr proxygen || true
git clone https://github.com/austincbrooks/proxygen \
    --depth 1 \
    --recurse-submodules \
    --shallow-submodules \
    --quiet
popd


# Publish the source code per the license requirements.
pushd "${PXG_SOURCE}"

cat << EOF > "README.md"
A file called `PROXYGEN-SOURCE-MODS.diff`
is in the root of each project to list any
source code modifications made by Proxygen.

To get source code for compilation tools,
operating system utilities, and other items
used here, please consult the Ubuntu package
management repositories. It is not practical
to bundle source code for an entire GPLv3
operating system when it is already widely
available online, and as an ISO image.
EOF

PXG_ARCHIVE=proxygen-linux-x64-source-$(date --utc "+%Y%m%d").tbz
tar \
    --owner=0 \
    --group=0 \
    --exclude-vcs \
    -cjf "${PXG_RELEASE}/${PXG_ARCHIVE}" \
    .

popd


### BUILD FFMPEG


# nasm
pushd "${PXG_SOURCE}/nasm"
./autogen.sh
PATH="${PXG_DIST}:${PATH}" \
    ./configure \
        --prefix="${PXG_BUILD}" \
        --bindir="${PXG_DIST}"
PATH="${PXG_DIST}:${PATH}" \
    make -j $(nproc)
make install
popd


# lame
pushd "${PXG_SOURCE}/lame"
PATH="${PXG_DIST}:${PATH}" \
    ./configure \
        --prefix="${PXG_BUILD}" \
        --bindir="${PXG_DIST}" \
        --enable-nasm \
        --enable-static \
        --disable-shared \
        --disable-cpml \
        --disable-decoder \
        --disable-frontend \
        --disable-gtktest
PATH="${PXG_DIST}:${PATH}" \
    make -j $(nproc)
make install
popd


# opus
pushd "${PXG_SOURCE}/opus"
./autogen.sh
PATH="${PXG_DIST}:${PATH}" \
    ./configure \
        --prefix="${PXG_BUILD}" \
        --bindir="${PXG_DIST}" \
        --enable-static \
        --disable-shared \
        --disable-doc \
        --disable-extra-programs
PATH="${PXG_DIST}:${PATH}" \
    make -j $(nproc)
make install
popd


# SVT-AV1
pushd "${PXG_SOURCE}/SVT-AV1"
PATH="${PXG_DIST}:${PATH}" \
    cmake \
        -B build \
        -G Ninja \
        -D CMAKE_INSTALL_PREFIX="${PXG_BUILD}" \
        -D CMAKE_BUILD_TYPE=Release \
        -D BUILD_SHARED_LIBS=OFF \
        -D BUILD_TESTING=OFF \
        -D BUILD_APPS=OFF \
        -D ENABLE_AVX512=ON
PATH="${PXG_DIST}:${PATH}" \
    ninja \
        -C build \
        -j $(nproc)
PATH="${PXG_DIST}:${PATH}" \
    ninja \
        -C build \
        install
popd


# zimg
pushd "${PXG_SOURCE}/zimg"
./autogen.sh
PATH="${PXG_DIST}:${PATH}" \
    ./configure \
        --prefix="${PXG_BUILD}" \
        --bindir="${PXG_DIST}"
PATH="${PXG_DIST}:${PATH}" \
    make -j $(nproc)
make install
popd


# ffmpeg
# See: https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# Run `./configure --help` for a list of --enable-* flags.
# An `--enable-nonfree` binary cannot be distributed.
# Legal and license:
#   https://www.ffmpeg.org/legal.html
#   https://ffmpeg.org/doxygen/trunk/md_LICENSE.html
# TODO: compare to BtbN and shotcut
# TODO: PIE/PIC support https://superuser.com/questions/1055889/how-to-build-ffmpeg-as-a-position-independent-executable-pie-or-pic
pushd "${PXG_SOURCE}/ffmpeg"
PATH="${PXG_DIST}:${PATH}" \
PKG_CONFIG_PATH="${PXG_BUILD}/lib/pkgconfig" \
    ./configure \
    --prefix="${PXG_BUILD}" \
    --bindir="${PXG_DIST}" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I${PXG_BUILD}/include" \
    --extra-ldflags="-L${PXG_BUILD}/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --enable-gpl \
    --enable-version3 \
    --enable-gnutls \
    --enable-libmp3lame \
    --enable-libopus \
    --enable-libsvtav1 \
    --enable-libzimg \
    --disable-doc \
    --disable-ffplay
PATH="${PXG_DIST}:${PATH}" \
    make -j $(nproc)
make install
popd


# Cleanup.
popd > /dev/null
exit 0
