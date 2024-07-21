# Proxygen Roadmap

## Status legend

- ❏ = To do
- ◷ = Partial
- ✓ = Complete

## Code objectives

- ❏ Coded with **Python**
- ❏ i18n/l10n with **gettext**
  - ❏ Plural forms
- ❏ Locale-aware with **locale**
  - ❏ Dates
  - ❏ Numbers
  - ❏ Sort order
    - ❏ Turkey Test
- ❏ Logged with **logging**
- ❏ CLI
  - ❏ **argparse**
- ❏ GUI
  - ❏ **Pillow**
  - ❏ **tkinter**
  - ❏ **CustomTkinter**

## Build objectives

- ❏ Formatted with **Ruff**
- ❏ Linted with **Ruff**
- ❏ Type checked with **Mypy**
- ❏ Unit tested with **unittest**
  - ❏ Dependency injection
- ❏ Compiled with **PyInstaller**
- ❏ Static executable of **FFmpeg**
- Documentation
  - ❏ User guides in **HTML**
  - ❏ Developer guides in **Markdown**
  - ❏ Python docstrings using **pydoc**
- Cross-platform support
  - Linux
    - ❏ x64
    - ❏ Portable archive as **gzip'd tar**
    - ❏ Friendly installer as **deb package**
  - Windows
    - ❏ x64
    - ❏ Portable archive as **zip**
    - ❏ Friendly installer using **Inno Setup**
  - macOS
    - ❏ x64 universal build?
  - All
    - ❏ SHA-256 hashes of assets
- Operating system integration
  - ❏ System-wide or user-only
  - ❏ App menu item with icon
  - ❏ **SVG** and **PNG** icons for .pxg files
  - ❏ "Open with" association for .pxg files
  - ❏ Proxygen executable can be scripted
    - ❏ Don't put `bin` folder in PATH
    - ❏ Bundled FFmpeg should not mask system FFmpeg
- ❏ Build scripts with **bash** or **batch**
- ❏ Automated builds with **GitHub Actions**
  - ❏ Nightly
  - ❏ Release

## Transcoding objectives

- ❏ Streams retain their stream index ID
- ❏ Convert variable frame rate to constant frame rate
- Simple options for specifying quality level
  - ❏ Lossless
  - ❏ Transparent
  - ❏ Balanced
  - ❏ Fast encode time
  - ❏ Small file size
- ❏ Gamma-aware scaling with [**zimg**](https://ffmpeg.org/ffmpeg-filters.html#zscale-1)

## Feature objectives

- ❏ Multi-node farm processing
- Advanced features
  - ❏ Disable screen saver and sleep modes
  - ❏ When done, sleep or power off computer
