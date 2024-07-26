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
import platform
import shutil
import sys
import os


def find_exe_dir() -> Path:
    """Returns the directory of the running executable."""

    if getattr(sys, "frozen", False):
        # Compressed executable, unpacked in /tmp.
        exe_dir = Path(sys.executable).parent.resolve()
    else:
        try:
            # Non-interactive script runner.
            exe_dir = Path(__file__).parent.resolve()
        except NameError:
            # Interactive command window.
            exe_dir = Path.cwd().resolve()

    if (exe_dir.parent / "PROXYGEN.root").exists():
        return exe_dir
    else:
        raise FileNotFoundError("Cannot find Proxygen root directory")


def find_ffmpeg() -> str | None:
    if platform.system() == "Windows":
        ffmpeg = "ffmpeg.exe"
    else:
        ffmpeg = "ffmpeg"

    exe_dir = find_exe_dir()
    print("exe_dir:", exe_dir)

    # Same-directory ffmpeg should always take precedence.
    probe_file = (exe_dir / ffmpeg).resolve()
    print("probe_file", probe_file)
    if probe_file.exists():
        return str(probe_file)

    # For running .py source code out of a portable archive.
    probe_file = (exe_dir / ".." / "bin" / ffmpeg).resolve()
    print("probe_file", probe_file)
    if probe_file.exists():
        return str(probe_file)

    # For running .py source code out of a local dev repo.
    probe_file = (exe_dir / ".." / "dist" / ffmpeg).resolve()
    print("probe_file", probe_file)
    if probe_file.exists():
        return str(probe_file)

    # Hunt for a system-wide ffmpeg in PATH.
    return shutil.which(ffmpeg)


def build_utvideo_command(ffmpeg: str, input: Path, output: Path, short_edge: int) -> list[str]:
    # TODO: Add sharpen filter after downscale where
    # amount depends on input/output size difference.

    # fmt: off
    return \
    [
        ffmpeg,
        "-i", str(input),
        "-to", "00:00:01.000",
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


def dir_walker(start_dir: Path, ffmpeg: str) -> None:
    for item in start_dir.iterdir():
        if item.is_dir():
            dir_walker(item, ffmpeg)
            continue
        output = Path() / ".." / "timeline" / item
        command = build_utvideo_command(ffmpeg, item, output, 360)
        output.parent.mkdir(exist_ok=True)
        subprocess.run(command)
        print(command)


def main() -> int:
    """This is the main method."""

    ffmpeg = find_ffmpeg()
    if not ffmpeg:
        return 1
    Path("timeline").mkdir(exist_ok=True)
    os.chdir("sources")
    dir_walker(Path(), ffmpeg)
    os.chdir("..")
    return 0


if __name__ == "__main__":
    sys.exit(main())
