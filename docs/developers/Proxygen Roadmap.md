# Proxygen Roadmap

## Status legend

- ❏ = To do
- ◷ = Partial
- ✓ = Complete

## Code objectives

- ❏ Coded with **Python**
- ❏ Logged with **logging**
- ❏ i18n/l10n with **gettext**
  - ❏ Plural forms
- ❏ Locale-aware with **locale**
  - ❏ Dates
  - ❏ Numbers
  - ❏ Currency
  - ❏ Sort order
    - ❏ Passes the Turkey Test
- ❏ CLI with **argparse**
- ❏ GUI with **tkinter** and **CustomTkinter**

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
  - ❏ Python docstrings in **HTML**
  - ❏ Developer guides in **Markdown**
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
  - ❏ System-wide or user-only
  - ❏ App menu item with icon
  - ❏ **SVG** and **PNG** icons for .pxg files
  - ❏ "Open with" association for .pxg files
  - ❏ Proxygen executable can be scripted
    - ❏ Don't put `bin` folder in PATH
    - ❏ Bundled FFmpeg should not mask system FFmpeg
- ❏ Build scripts with **bash** or **batch**
- ❏ CI/CD builds with **GitHub Actions**
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

## Feature objectives

- ❏ Multi-node farm processing
- Advanced features
  - ❏ Disable screen saver and sleep modes
