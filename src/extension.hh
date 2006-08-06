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

#include <ruby.h>

extern "C" {
  void Init_hunspell()  __attribute__((visibility("default")));
}

class Hunspell;

extern VALUE cHunspell;
VALUE hunspell_free(Hunspell *pHS);
VALUE hunspell_new(VALUE klass, VALUE affpath, VALUE dpath);
VALUE hunspell_spell(VALUE self, VALUE word);
VALUE hunspell_suggest(VALUE self, VALUE word);
