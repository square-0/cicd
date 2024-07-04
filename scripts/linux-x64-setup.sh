#!/usr/bin/env bash


# Set working directory to the local repo root.
pushd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/.." > /dev/null


# Add pip's script directories to the PATH.
mkdir -p ~/.local/bin
echo export PATH="\${PATH}:${HOME}/.local/bin" >> ~/.bashrc


# Prevent __pycache__ data from ending up in packaged release.
mkdir -p ~/.cache/Python
echo export PYTHONPYCACHEPREFIX="${HOME}/.cache/Python" >> ~/.bashrc


# Source new changes to the environment.
source ~/.bashrc


# Install Linux dependencies.
sudo apt-get update
sudo apt-get install -y \
    software-properties-common
sudo add-apt-repository -y \
    ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3.12-tk \
    gettext \
    lintian


# Install Python dependencies.
# Use a venv so that only required modules
# make it into the PyInstaller executable
# to reduce file size and attack surface.
python3.12 -m venv venv
source venv/bin/activate
python3.12 -m ensurepip --upgrade
python3.12 -m pip install --upgrade pip
python3.12 -m pip install -r src/requirements.txt
# TODO: pip install black/flake8 in requirements.txt
# TODO: make two: venv/test venv/prod


# Cleanup.
popd
