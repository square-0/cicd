# ![Proxygen icon](icons/proxygen-32.png) Proxygen

[![linux-x64 Build Status](https://github.com/square-0/cicd/actions/workflows/linux-x64.yml/badge.svg)](https://github.com/square-0/cicd/actions/workflows/linux-x64.yml)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

## Installing

Each supported platform has a user-friendly setup
wizard and a portable archive version available.
The portable archive can be unpacked and run from
anywhere, including USB drives and network folders.

Both distributions include an executable version
and a source version of Proxygen. The executable
version does not require a Python interpreter or
any dependencies to run, while the source version
requires both. Look at a file called
`scripts/<platform>/setup` for a list of those
dependencies.

However, Proxygen is most useful when the operating
system associates `.pxg` files with Proxygen, and
the executable is in the PATH for scripting. Look
in the unpacked portable archive for a file called
`bin/os_<platform>_register_*`. This script will
integrate Proxygen with the operating system. This
is the same script that the wizard version of
Proxygen calls during installation.

## Building

Proxygen, by intentional design, can be built from
an Ubuntu Desktop ISO that's running as a virtual
machine or in LiveUSB mode. Using one of these
methods for local development work is highly
recommended.

As a by-product of this design, Proxygen is very
easy to build with GitHub Actions. This is how
nightly builds and release files are created.

To understand the Proxygen build process, look at
`.github/workflows/nightly` and trace the process
from there.

## Contributing

These are areas that welcome contributions:

- **Build scripts**
  - Linux ARM
  - Windows ARM
  - macOS x64 and ARM

- **Refinements**
  - Security
  - Performance
  - Data integrity
  - Decoder support

Meanwhile, encoder support and quality settings are a
more strategic matter. Proxygen aims to be simple and
highly effective for key use cases. Proxygen avoids
redundant encoders unless they are industry standards.
As such, any contributors wishing to add encoders or
modify quality settings should first open an issue and
state what they want to do. The new idea may or may
not be in alignment with where the maintainers want
Proxygen to go. It is better to determine an idea's
viability early rather than spend time creating
something that may not get used.
