# ruby-hunspell - Ruby bindings for Hunspell library
# Copyright (C) 2006, Diego Pettenò
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this software; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

require 'hunspell/parsers'
require 'test/unit'

class TPTest < Test::Unit::TestCase
  def setup
    @tp = Hunspell::TextParser.new
  end

  def test_next_token
    @tp.put_line("test next token")
    assert @tp.next_token == "test"
    assert @tp.next_token == "next"
    assert @tp.next_token == "token"
    assert @tp.next_token == nil
  end

  def test_change_token
    @tp.put_line("test next token")
    @tp.next_token
    @tp.next_token

    assert @tp.change_token("change")

    assert @tp.get_line == "test change token"
  end
end
