#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Compile .po files into .mo files.
find locales -name proxygen.po -exec \
    bash -c \
    'msgfmt --output-file "${0/.po/.mo}" "${0}"' \
    {} \;


# Cleanup.
popd
