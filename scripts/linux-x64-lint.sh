#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Activate virtual environment.
source venv/bin/activate


# black
# flake8


# Cleanup.
popd
