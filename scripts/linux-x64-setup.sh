#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Add pip's module directories to the PATH.
mkdir -p ~/.local/bin
echo export PATH="\${PATH}:${HOME}/.local/bin" >> ~/.bashrc


# Write __pycache__ files to home rather than repo.
mkdir -p ~/.cache/Python
echo export PYTHONPYCACHEPREFIX="${HOME}/.cache/Python" >> ~/.bashrc


# Source new changes to the environment.
source ~/.bashrc


# Install Linux dependencies.
sudo apt-get update
sudo apt-get install -y \
    python3-venv \
    python3-pip


# Install Python dependencies.
# Use a venv so that only required modules
# make it into the PyInstaller executable
# to reduce file size and attack surface.
python3 -m venv venv
source venv/bin/activate
python3 -m pip install -r src/requirements.txt


# Cleanup.
popd
