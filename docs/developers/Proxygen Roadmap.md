# Proxygen Roadmap

## Status legend

- ❏ = To do
- ◷ = Partial
- ✓ = Complete

## Build objectives

- ❏ Coded with **Python**
- ❏ Formatted with **Ruff**
- ❏ Linted with **Ruff**
- ❏ Type checked with **Mypy**
- ❏ Unit tested with **unittest**
- ❏ I18N/L10N + plurals with **gettext**
- ❏ Numbers/dates localized with **locale**
- ❏ Compiled with **PyInstaller**
- ❏ Static executable of **FFmpeg**
- Documentation
  - ❏ User guides in **HTML**
  - ❏ Developer guides in **HTML**
  - ❏ Python docstrings in **HTML**
- Cross-platform support
  - Linux
    - ❏ x64
    - ❏ ARM
    - ❏ Portable archive as **gzip'd tar**
    - ❏ Friendly installer as **deb package**
  - Windows
    - ❏ x64
    - ❏ ARM
    - ❏ Portable archive as **zip**
    - ❏ Friendly installer using **Inno Setup**
  - macOS
    - ❏ x64 universal build
    - ❏ ARM Apple Silicon
  - All
    - ❏ SHA-256 hashes of assets
- Operating system integration
  - ❏ App menu item with icon
  - ❏ **SVG** and **PNG** icons for .pxg files
  - ❏ "Open with" association for .pxg files
  - ❏ Proxygen executable in PATH, but not bundled FFmpeg
- ❏ Build scripts with **bash**
- ❏ Nightly and release builds with **GitHub Actions**

## Transcoding objectives

- ❏ Streams retain their stream index ID
- ❏ Convert variable frame rate to constant frame rate
- Simple options for specifying quality level
  - ❏ Lossless
  - ❏ Transparent
  - ❏ Balanced
  - ❏ Fast encode time
  - ❏ Small file size

## Feature objectives

- ❏ Logging
- ❏ Multi-node farm processing
- Advanced features
  - ❏ Disable screen saver and sleep modes
