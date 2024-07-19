# Copyright (c) 2024, Austin Brooks <ab.proxygen atSign outlook dt com>
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

from pathlib import Path
import sys


if len(sys.argv) < 2:
    print("ERROR: Full tag name argument was not passed.")
    sys.exit(99)


Path("release").mkdir(parents=True, exist_ok=True)

with open("CHANGELOG.md", "r", encoding="utf-8") as all_handle:
    with open("release/CHANGELOG-release.md", "w", encoding="utf-8") as latest_handle:
        vnext = "vNext"
        tag_prefix = "refs/tags/"
        if sys.argv[1].startswith(tag_prefix):
            tag_name = sys.argv[1][len(tag_prefix):]
        else:
            tag_name = vnext
        if tag_name.startswith("v"):
            version_header = f"## {tag_name}"
        else:
            version_header = f"## {vnext}"

        echo_flag = False
        for line in all_handle:
            if echo_flag == False:
                if line.strip() == version_header:
                    echo_flag = True
            else:
                if line.startswith("## "):
                    sys.exit(0)
                else:
                    latest_handle.write(line)
