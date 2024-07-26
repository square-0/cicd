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

import unittest
import locale
import os

import i18n


class TestMain(unittest.TestCase):
    mo_msg: str = "Have .mo files been rebuilt lately? ./scripts/platform/l10n"

    def setUp(self) -> None:
        os.chdir("src")

    def tearDown(self) -> None:
        os.chdir("..")
        locale.setlocale(locale.LC_ALL, "en_US.UTF-8")

    def test_mo_found(self) -> None:
        i18n.set_locale("en_US.UTF-8")
        self.assertEqual(i18n.msg1("l10n unit test 1"), "l10n unit test message", self.mo_msg)
        self.assertEqual(i18n.msgN("l10n unit test 2", "l10n unit test 2", 1), "l10n unit test singular", self.mo_msg)
        self.assertEqual(i18n.msgN("l10n unit test 2", "l10n unit test 2", 2), "l10n unit test plural", self.mo_msg)

    def test_english(self) -> None:
        i18n.set_locale("en_US.UTF-8")
        self.assertNotEqual(i18n.xfrm("LİMANI"), i18n.xfrm("limanı"))

    def test_turkic(self) -> None:
        i18n.set_locale("tr_TR.UTF-8")
        self.assertEqual(i18n.xfrm("LİMANI"), i18n.xfrm("limanı"))


if __name__ == "__main__":
    unittest.main()
