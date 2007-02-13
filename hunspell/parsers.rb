#  ruby-hunspell - Ruby bindings for Hunspell library
#  Copyright (C) 2006-2007, Diego Pettenò
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this software; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

require 'rust'

Rust::Bindings::create_bindings Rust::Bindings::LangCxx, "parsers" do |b|
  b.include_header 'textparser.hxx', Rust::Bindings::HeaderGlobal
  b.include_header 'latexparser.hxx', Rust::Bindings::HeaderGlobal
  b.include_header 'firstparser.hxx', Rust::Bindings::HeaderGlobal
  b.include_header 'manparser.hxx', Rust::Bindings::HeaderGlobal
  b.include_header 'htmlparser.hxx', Rust::Bindings::HeaderGlobal

  b.add_namespace "Hunspell", "" do |ns|
    ns.add_cxx_class "TextParser" do |klass|
      klass.add_constructor

      klass.add_method "put_line" do |method|
        method.add_parameter "char *", "line"
      end

      klass.add_method "get_line", "const char *"
      klass.add_method "get_prevline" do |method|
        method.add_parameter "int", "n"
      end

      klass.add_method "next_token", "const char *"
      klass.add_method "change_token", "bool" do |method|
        method.add_parameter "char *", "word"
      end

      klass.add_method "get_tokenpos", "int"
      klass.add_method "is_wordchar" do |method|
        method.add_parameter "char *", "w"
        method.add_alias "wordchar?"
      end

      klass.add_method "get_latin1" do |method|
        method.add_parameter "char *", "s"
      end

      klass.add_method "next_char", "const char *"
    end

    ns.add_cxx_class "LaTeXParser" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "char *", "wc", false, "NULL"
      end
    end

    ns.add_cxx_class "FirstParser" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "char *", "wc", false, "NULL"
      end
    end

    ns.add_cxx_class "ManParser" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "char *", "wc", false, "NULL"
      end
    end

    ns.add_cxx_class "HTMLParser" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "char *", "wc", false, "NULL"
      end
    end

  end

end
