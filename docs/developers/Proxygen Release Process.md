# Proxygen Release Process

## Update dependencies

- Any libraries added or deleted?
  - Are the licenses compatible with GPLv3?
  - Is the source code included in the source tarball?
  - Are the library licenses added to `licenses/<library>`?
  - Are the libraries referenced in the About string?

- scripts/*-setup1
  - scripts/*-env
  - Linux packages

- scripts/*-setup2
  - FFmpeg

- Python
  - Language version in `scripts/*-setup`
  - `PXG_PY_CMD` in `scripts/*-env`

- PIP
  - `src/requirements.txt`

- Installers
  - Inno Setup

## Code checks

- All "# FIXME:" issues fixed
- All lint checks should pass
- All unit tests should pass
- All source code and COPYRIGHT.txt has copyright date updated to include current year

## Check build logs for errors

- Run each platform's GitHub Actions workflow in artifact mode
- Review logs for warnings and errors

## Update documentation

## Update CHANGELOG.md

Entry types:

- **New:** A new feature or functionality
- **Fixed:** Bug fix for unintentional problems
- **Changed:** New behavior that affects a user's processes
- **Improved:** Better or faster results using same processes
- **Security:** Addresses a security or vulnerability issue
- **Deprecated:** Warning that a feature will soon be removed
- **Removed:** A feature is no longer available

formatting style

## Send strings to translators

- `scripts/*-i18n`

## Beta period

a README shield to indicate if in beta period

## Merge strings from translators

- Push new `.po` files to GitHub

## Create a release

### GitHub web site

### `gh` command line

can target a past commit

