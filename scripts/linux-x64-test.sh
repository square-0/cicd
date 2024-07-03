#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Activate virtual environment.
source venv/bin/activate


# Run all unit tests.
python3.12 -m unittest discover -t src -s src/tests -p *.py


# Cleanup.
popd