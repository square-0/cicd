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

## GitHub Actions and workflow notes

[https://stackoverflow.com/questions/63014786/how-to-schedule-a-github-actions-nightly-build-but-run-it-only-when-there-where] last answer
[https://stackoverflow.com/questions/60418323/triggering-a-new-workflow-from-another-workflow]
[https://stackoverflow.com/questions/75679683/how-can-i-auto-generate-a-release-note-and-create-a-release-using-github-actions]
[https://github.com/softprops/action-gh-release]
[https://github.com/cli/cli/discussions/3000]
[https://stackoverflow.com/questions/75237631/how-to-delete-all-releases-and-tags-in-a-github-repository]

## I18N/L10N

[https://github.com/python/cpython/issues/62519]
[https://stackoverflow.com/questions/56545202/french-translation-raises-valueerrorinvalid-token-in-plural-form-s-value]
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"
"Plural-Forms: nplurals=2; plural=(n != 1);\n"
[https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/Header-Entry.html]
[https://www.gnu.org/savannah-checkouts/gnu/gettext/manual/html_node/Translating-plural-forms.html]
[https://translationproject.org/html/welcome.html]
[https://stackoverflow.com/questions/14547631/python-locale-error-unsupported-locale-setting]
[Turkey Test](https://stackoverflow.com/questions/40348174/should-i-use-python-casefold)

Poedit .PO file editor GUI

- [https://github.com/vslavik/poedit]
- [https://poedit.net]

[Block screen saver](https://stackoverflow.com/questions/63076389/python-prevent-the-screen-saver)

## PyInstaller

As noted in the CPython tutorial Appendix, for Windows a file extension of .pyw suppresses the console window that normally appears. Likewise, a console window will not be provided when using a myscript.pyw script with PyInstaller.

noconsole before onefile:
pyinstaller --noconsole --onefile --windowed --icon=favicon.ico main.py

## Beta period indicators

```text
![auto-commit-msg](https://img.shields.io/badge/dynamic/json?label=vscode&query=%24.engines.vscode&url=https%3A%2F%2Fraw.githubusercontent.com%2FMichaelCurrin%2Fauto-commit-msg%2Fmaster%2Fpackage.json)

[![OS - Linux](https://img.shields.io/badge/OS-Linux-blue?logo=linux&logoColor=white)](https://www.linux.org/ "Go to Linux homepage")
```

[https://github.com/MichaelCurrin/badge-generator/blob/master/README.md]

