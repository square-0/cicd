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


if len(sys.argv) < 2:
    print("ERROR: Tag name argument was not passed")
    sys.exit(500)


with open("CHANGELOG.md", "r", encoding="utf-8") as all_handle:
    with open("CHANGELOG-latest.md", "w", encoding="utf-8") as latest_handle:
        echo_flag = False

        tag_prefix = "refs/tags/"
        if sys.argv[1].startswith(tag_prefix):
            version_header = f"## {sys.argv[1][len(tag_prefix):]}"
        else:
            version_header = "## vNext"

        for line in all_handle:
            if echo_flag == False:
                if line.strip() == version_header:
                    echo_flag = True
                    next(all_handle)
            else:
                if line.startswith("## "):
                    sys.exit(0)
                else:
                    latest_handle.write(line)
