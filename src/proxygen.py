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

from pathlib import Path
import subprocess
import sys
import os


def build_command(input: Path, output: Path, short_edge: int) -> list[str]:
    # TODO: Add sharpen filter after downscale where
    # amount depends on input/output size difference.

    # fmt: off
    return \
    [
        "ffmpeg",
        "-i", str(input),
        "-filter:v",
        (
            "zscale="
                f"w=if(gt(iw\\,ih)\\,-2\\,{short_edge}):"
                f"h=if(gt(iw\\,ih)\\,{short_edge}\\,-2):"
                "filter=spline36:"
                "dither=error_diffusion"
        ),
        "-c:V", "utvideo",
        "-c:a", "pcm_s24le",
        "-f", "matroska",
        "-y",
        str(output)
    ]
    # fmt: on


def dir_walker(start_dir: Path) -> None:
    for item in start_dir.iterdir():
        if item.is_dir():
            dir_walker(item)
            continue
        output = Path() / ".." / "timeline" / item
        command = build_command(item, output, 360)
        output.parent.mkdir(exist_ok=True)
        subprocess.run(command)
        print(command)


def main() -> int:
    """This is the main method."""

    Path("timeline").mkdir(exist_ok=True)
    os.chdir("sources")
    dir_walker(Path())
    os.chdir("..")
    return 0


if __name__ == "__main__":
    sys.exit(main())
