# Proxygen Developer Notes

## File formats

- [Markdown](https://www.markdownguide.org/basic-syntax/)

## How to find dependencies of Linux Python executable for .deb package

./scripts/linux-x64-build.sh
cd dist/exe
mkdir debian
touch debian/control
dpkg-shlibdeps -O proxygen

## Un/Install .deb packge

sudo dpkg -i proxygen-linux-x64-{VER}.deb
sudo dpkg -r proxygen
sudo dpkg -P proxygen

## Associate program with MIME/extension in Linux

[https://www.reddit.com/r/xfce/comments/13vl393/how_to_associate_open_with_programs_exactly_by/]
[https://forums.debian.net/viewtopic.php?t=153472]

## Building PyInstaller to create PIE/ASLR executables

[https://github.com/pyinstaller/pyinstaller/issues/6532]
[https://stackoverflow.com/questions/53584395/how-to-recompile-the-bootloader-of-pyinstaller]
env PYINSTALLER_COMPILE_BOOTLOADER
[https://pyinstaller.org/en/stable/bootloader-building.html]
[https://github.com/pyinstaller/pyinstaller/issues/6477]
