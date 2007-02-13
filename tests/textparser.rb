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

tp = Hunspell::TextParser.new

tp.put_line("hi, how's life? good")

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "hi"

exit 2 unless tp.change_token("hello")

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "hello"

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "how"

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "s"

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "life"

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != "good"

token = tp.next_token
puts "Token: #{token}"
exit 1 if token != nil

puts "Line: #{tp.get_line}"
exit 1 if tp.get_line != "hello, how's life? good"
