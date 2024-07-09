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

import gettext
import decimal
import datetime


_pxg_translation: gettext.GNUTranslations | gettext.NullTranslations | None = None


def i18n_set_locale(language: str | None = None) -> None:
    global _pxg_translation

    languages = [language] if language else None
    _pxg_translation = gettext.translation("proxygen", "../locales", languages, fallback=True)

    # loc = language if language else ""
    # locale.setlocale(locale.LC_ALL, loc)


def i18n_msg(msgid: str) -> str:
    global _pxg_translation

    if not _pxg_translation:
        i18n_set_locale()

    if _pxg_translation:
        return _pxg_translation.gettext(msgid)
    else:
        raise ValueError("Translation not found")


def i18n_msgN(msgid1: str, msgidN: str, count: int) -> str:
    global _pxg_translation

    if not _pxg_translation:
        i18n_set_locale()

    if _pxg_translation:
        return _pxg_translation.ngettext(msgid1, msgidN, count)
    else:
        raise ValueError("Translation not found")


def i18n_int(number: bool | int | float | decimal.Decimal | str) -> str:
    return "{0:n}".format(int(number))


def i18n_dec(number: bool | int | float | decimal.Decimal | str) -> str:
    return "{0:n}".format(decimal.Decimal(number))


def i18n_date(dt: datetime.datetime) -> str:
    return dt.strftime("%x")


def i18n_time(dt: datetime.datetime) -> str:
    return dt.strftime("%X")
