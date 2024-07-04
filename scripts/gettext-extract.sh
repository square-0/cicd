#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Retrieve version number from the build.
PXG_VERSION=$(cat dist/exe/VERSION)


# Extract strings for translation into a fresh template.
xgettext \
    --package-name Proxygen \
    --package-version ${PXG_VERSION} \
    --copyright-holder "Austin Brooks <ab.proxygen@outlook.com>" \
    --msgid-bugs-address "Austin Brooks <ab.proxygen@outlook.com>" \
    --default-domain proxygen \
    --output locales/proxygen.pot \
    --width 72 \
    --language Python \
    src/*.py


# Merge new strings into existing .po files.
find locales -name proxygen.po -exec \
    msgmerge \
    {} \
    locales/proxygen.pot \
    --width 72 \
    --update \;


# Cleanup.
popd
