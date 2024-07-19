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

from typing import cast, Iterable
from dataclasses import dataclass
import unicodedata
import locale
import gettext
import decimal
import datetime


"""
See:
https://www.gnu.org/software/gettext/manual/html_node/index.html
"""

# TODO: scan locale stdlib module for anything else to implement, esp string_format()

@dataclass
class _LocaleParts:
    """
    See:
    ISO 639 list of language codes
    ISO 3166 list of country codes
    BCP 47 puts them together as IETF language tags
        https://en.wikipedia.org/wiki/IETF_language_tag
    """

    language: str
    region: str | None
    extension: str | None
    variant: str | None
    encoding: str | None

    @property
    def bcp47(self) -> str:
        if self.region:
            return f"{self.language}_{self.region.upper()}"
        else:
            return self.language


_i18n_translation: gettext.GNUTranslations | gettext.NullTranslations | None
_i18n_rtl: bool | None
_i18n_turkic: bool | None


# TODO:
def i18n_list_locales() -> list[str]: ...  # type: ignore[empty-body]


def i18n_set_locale(locale_code: str | None = None) -> None:
    """Sets the locale and translation for the entire app.

    """

    global _i18n_translation
    global _i18n_rtl
    global _i18n_turkic

    # Set app-wide locale.
    # TODO: set _i18n_locale_code and only check for it, assume the rest
    if not set(['_i18n_translation', '_i18n_rtl', '_i18n_turkic']).issubset(set(globals())):
        _i18n_translation = None
        _i18n_rtl = None
        _i18n_turkic = None
    if locale_code is None:
        if _i18n_translation and _i18n_rtl is not None and _i18n_turkic is not None:
            return
        locale.setlocale(locale.LC_ALL, "")
        new_locale = ".".join(cast(Iterable[str], locale.getlocale(locale.LC_NUMERIC)))
    else:
        locale.setlocale(locale.LC_ALL, locale_code)
        new_locale = locale_code

    locale_parts = _get_locale_parts(new_locale)

    # Set the gettext translation.
    languages = [locale_parts.bcp47, locale_parts.language]
    _i18n_translation = gettext.translation("proxygen", "../locales", languages, fallback=True)

    # Set the right-to-left flag.
    rtl_list = _file_to_list("../locales/rtl.txt")
    _i18n_rtl = locale_parts.language in rtl_list

    # Set the Turkic flag.
    turkic_list = _file_to_list("../locales/turkic.txt")
    _i18n_turkic = locale_parts.language in turkic_list


def i18n_msg(msgid: str) -> str:
    global _i18n_translation

    i18n_set_locale()

    if _i18n_translation:
        # TODO: if rtl, reverse strings except {variable}
        return _i18n_translation.gettext(msgid)
    else:
        raise ValueError("Translation not found")


def i18n_msgN(msgid1: str, msgidN: str, count: int) -> str:
    global _i18n_translation

    i18n_set_locale()

    if _i18n_translation:
        # TODO: if rtl, reverse strings except {variable}
        return _i18n_translation.ngettext(msgid1, msgidN, count)
    else:
        raise ValueError("Translation not found")


def i18n_int(number: bool | int | float | decimal.Decimal | str) -> str:
    return "{0:n}".format(int(number))


def i18n_dec(number: bool | int | float | decimal.Decimal | str, rounding: int | None = None) -> str:
    # TODO: support rounding
    return "{0:n}".format(decimal.Decimal(number))


def i18n_date(dt: datetime.datetime) -> str:
    return dt.strftime("%x")


def i18n_time(dt: datetime.datetime) -> str:
    return dt.strftime("%X")


def i18n_local() -> str:
    return datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S%z")


def i18n_utc() -> str:
    """This format can be parsed by the GNU `date --date` command for log analysis."""

    return datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")


def i18n_xfrm(string: str) -> str:
    """Casefolding for locale-aware comparison and sorting.

    Creates a key suitable for case-insensitive locale-aware
    comparison and sorting like locale.strxfrm().

    See:
    https://stackoverflow.com/questions/40348174/should-i-use-python-casefold
    https://stackoverflow.com/questions/16467479/normalizing-unicode
    https://stackoverflow.com/questions/11121636/sorting-list-of-string-with-specific-locale-in-python
    """
    global _i18n_turkic

    new_string = unicodedata.normalize("NFD", string)
    if _i18n_turkic:
        new_string = unicodedata.normalize("NFC", new_string)
        new_string = new_string.replace("\u0049", "\u0131")
        new_string = new_string.replace("\u0130", "\u0069")
    new_string = new_string.casefold()
    new_string = unicodedata.normalize("NFD", new_string)

    return new_string


def i18n_sort(items: Iterable[str], reverse: bool = False) -> Iterable[str]:
    return sorted(items, key=locale.strxfrm, reverse=reverse)


def i18n_isort(items: Iterable[str], reverse: bool = False) -> Iterable[str]:
    items_ci = [i18n_xfrm(item) for item in items]
    return i18n_sort(items_ci, reverse)


def i18n_ltr() -> bool:
    global _i18n_rtl

    i18n_set_locale()

    if _i18n_rtl is None:
        raise ValueError("Language direction is unknown")

    return not _i18n_rtl


def i18n_rtl() -> bool:
    global _i18n_rtl

    i18n_set_locale()

    if _i18n_rtl is None:
        raise ValueError("Language direction is unknown")

    return _i18n_rtl


# TODO:
def i18n_atoi(string: str) -> int: ...  # type: ignore[empty-body]


# TODO:
def i18n_atof(string: str) -> float: ...  # type: ignore[empty-body]


####  HELPERS  #########################################################


def _file_to_list(filename: str) -> list[str]:
    items = list[str]()

    with open(filename, "r", encoding="utf-8") as file_handle:
        for line in map(str.strip, file_handle):
            if not line:
                continue
            if line.startswith("#"):
                continue
            items.append(line)

    return items


def _get_locale_parts(locale_code: str) -> _LocaleParts:
    """
    Expected format:
    language[_region][_extension][@variant][.encoding]
    Hyphens can be used in place of underscores.
    """

    dot_split = locale_code.casefold().split(".")

    encoding = dot_split[1] if len(dot_split) > 1 else None

    at_split = dot_split[0].split("@")

    variant = at_split[1] if len(at_split) > 1 else None

    dash_split = at_split[0].replace("_", "-").split("-", 2)

    language = dash_split[0]

    if len(dash_split) > 2:
        region = dash_split[1]
        extension = dash_split[2]
    elif len(dash_split) > 1:
        region = dash_split[1]
        extension = None
    else:
        region = None
        extension = None

    return _LocaleParts(language=language, region=region, extension=extension, variant=variant, encoding=encoding)
