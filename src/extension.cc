/* ruby-hunspell - Ruby bindings for Hunspell library
   Copyright (C) 2006, Diego Pettenò

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this software; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "extension.hh"

extern "C" {
  void Init_hunspell() {
    cHunspell = rb_define_class("Hunspell", rb_cObject);
    rb_define_singleton_method(cHunspell, "new", RUBY_METHOD_FUNC(hunspell_new), 2);
    rb_define_method(cHunspell, "spell", RUBY_METHOD_FUNC(hunspell_spell), 1);
    rb_define_method(cHunspell, "suggest", RUBY_METHOD_FUNC(hunspell_suggest), 1);
  }
}
