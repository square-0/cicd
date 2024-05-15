#!/usr/bin/env bash

pushd ..
python3 -OO -m PyInstaller \
    --noconfirm \
    --clean \
    --specpath build \
    --workpath build \
    --distpath dist \
    --debug all \
    --noupx \
    --onefile \
    src/main.py
popd

