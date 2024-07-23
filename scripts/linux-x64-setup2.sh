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


# Create/clean the build environment.
# Leave the dist area intact.
mkdir -p downloads
mkdir -p build
mkdir -p dist
mkdir -p release
find downloads -mindepth 1 -delete
find build -mindepth 1 -delete
mkdir -p build/lib/pkgconfig


# Get source code.
pushd downloads

# NASM
git clone https://github.com/netwide-assembler/nasm \
    || exit 99

# zimg
git clone https://github.com/sekrit-twc/zimg && \
pushd zimg && \
git submodule update --init --recursive && \
popd \
    || exit 99

# FFmpeg
wget \
    https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 \
    --output-document ffmpeg-snapshot.tar.bz2 && \
tar -xjf ffmpeg-snapshot.tar.bz2 && \
rm ffmpeg-snapshot.tar.bz2 \
    || exit 99

# Proxygen
git clone https://github.com/austincbrooks/proxygen \
    || exit 99

popd


# Publish the source code per the license requirements.
pushd downloads
PXG_RELEASE=proxygen-linux-x64-source-$(date --utc "+%Y%m%d").tbz
tar \
    --owner=0 \
    --group=0 \
    --exclude-vcs \
    -cjf "../release/${PXG_RELEASE}" \
    . \
    || exit 99
popd


# Build NASM.
# See: https://bugzilla.nasm.us/show_bug.cgi?id=3392557
sudo apt-get install -y \
    asciidoc && \
pushd downloads/nasm && \
./autogen.sh && \
PATH="$(readlink -f ../../dist):${PATH}" \
    ./configure \
    --prefix="$(readlink -f ../../build)" \
    --bindir="$(readlink -f ../../dist)" && \
PATH="$(readlink -f ../../dist):${PATH}" \
    make -j$(nproc) && \
make manpages && \
make install && \
hash -r && \
popd \
|| exit 99


# Build zimg (zscale filter).
pushd downloads/zimg && \
./autogen.sh && \
PATH="$(readlink -f ../../dist):${PATH}" \
    ./configure \
    --prefix="$(readlink -f ../../build)" \
    --bindir="$(readlink -f ../../dist)" && \
PATH="$(readlink -f ../../dist):${PATH}" \
    make -j$(nproc) && \
make install && \
hash -r && \
popd \
|| exit 99


# Build FFmpeg.
# See: https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu
# Run `./configure --help` for a list of --enable-* flags.
pushd downloads/ffmpeg && \
PATH="$(readlink -f ../../dist):${PATH}" \
PKG_CONFIG_PATH="$(readlink -f ../../build/lib/pkgconfig)" \
    ./configure \
    --prefix="$(readlink -f ../../build)" \
    --bindir="$(readlink -f ../../dist)" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$(readlink -f ../../build)/include" \
    --extra-ldflags="-L$(readlink -f ../../build)/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --enable-gpl \
    --enable-gnutls \
    --enable-libass \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libvorbis \
    --enable-libzimg \
    --enable-nonfree \
    --disable-doc \
    --disable-ffplay && \
PATH="$(readlink -f ../../dist):${PATH}" \
    make -j$(nproc) && \
make install && \
hash -r && \
popd \
|| exit 99


# Cleanup.
popd > /dev/null
exit 0
