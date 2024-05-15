#!/usr/bin/env bash

echo export PATH=\$PATH:$HOME/.local/bin >> ~/.bashrc
source ~/.bashrc

sudo apt-get update
sudo apt-get install -y python3-pip
python3 -m pip install pyinstaller

# pip venv, create virtual environment, pip only required libs,
# so resultant pyinstaller exe is small as possible

