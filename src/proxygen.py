# Copyright (c) 2024, Austin Brooks <ab.proxygen@outlook.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import sys

from global_logs import *
from global_i18n import *


def main() -> int:
    """This is the main method."""

    pxg_set_locale("es")

    print(i18n_msg("Hello, world!"))

    count = 1
    msg = i18n_msgN("All {0} of you", "Oops, {0} of you", count)
    print(msg.format(count))

    count = 32
    msg = i18n_msgN("All {0} of you", "Oops, {0} of you", count)
    print(msg.format(count))

    return 0


if __name__ == "__main__":
    sys.exit(main())
