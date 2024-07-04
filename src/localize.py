# Copyright (C) 2024, Austin Brooks <ab.proxygen@outlook.com>
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

import gettext


def _(msgid: str) -> str:
    if '_pxg_translation' not in globals():
        pxg_set_translation()

    global _pxg_translation
    return _pxg_translation.gettext(msgid)


def ngettext(msgid1: str, msgidN: str, num: int) -> str:
    if '_pxg_translation' not in globals():
        pxg_set_translation()

    global _pxg_translation
    return _pxg_translation.ngettext(msgid1, msgidN, num)


def pxg_set_translation(language: str=None) -> None:
    languages = [language] if language else None

    global _pxg_translation
    _pxg_translation = gettext.translation("proxygen", "../locales", languages, fallback=True)
