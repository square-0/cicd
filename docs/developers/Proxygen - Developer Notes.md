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
https://www.reddit.com/r/xfce/comments/13vl393/how_to_associate_open_with_programs_exactly_by/
https://forums.debian.net/viewtopic.php?t=153472

