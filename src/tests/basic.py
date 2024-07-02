# Copyright (c) 2024, Austin Brooks <square-zero@outlook.com>
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

import proxygen
import config

class TestMain(unittest.TestCase):
    def test_main(self):
        self.assertEqual(proxygen.main(), 0)

    def test_random(self):
        self.assertEqual(config.random_method(), 42)

if __name__ == '__main__':
    unittest.main()
