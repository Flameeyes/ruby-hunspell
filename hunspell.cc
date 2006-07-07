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

#ifdef HAVE_HUNSPELL_HUNSPELL_HXX
# include <hunspell/hunspell.hxx>
#else
# include <hunspell.hxx>
#endif

static VALUE cHunspell;

static VALUE hunspell_free(Hunspell *pHS) {
  delete pHS;
}

static VALUE hunspell_new(VALUE klass, VALUE affpath, VALUE dpath) {
  Hunspell *pHS = new Hunspell(STR2CSTR(affpath), STR2CSTR(dpath));
  VALUE tdata = Data_Wrap_Struct(klass, 0, hunspell_free, pHS);
  
  return tdata;
}

static VALUE hunspell_spell(VALUE self, VALUE word) {
  Hunspell *ptr;
  Data_Get_Struct(self, Hunspell, ptr);
  
  return ptr->spell(STR2CSTR(word)) ? Qtrue : Qfalse;
}

static VALUE hunspell_suggest(VALUE self, VALUE word) {
  Hunspell *ptr;
  Data_Get_Struct(self, Hunspell, ptr);

  char **suggestions = NULL;
  int ns = ptr->suggest(&suggestions, STR2CSTR(word));
  
  VALUE rubysuggestions = rb_ary_new2(ns);
  for ( int i = 0; i < ns; i++ ) {
    rb_ary_push(rubysuggestions, rb_str_new2(suggestions[i]));
    free(suggestions[i]);
  }
  free(suggestions);
  
  return rubysuggestions;
}

extern "C" {
  void Init_hunspell() {
    cHunspell = rb_define_class("Hunspell", rb_cObject);
    rb_define_singleton_method(cHunspell, "new", RUBY_METHOD_FUNC(hunspell_new), 2);
    rb_define_method(cHunspell, "spell", RUBY_METHOD_FUNC(hunspell_spell), 1);
    rb_define_method(cHunspell, "suggest", RUBY_METHOD_FUNC(hunspell_suggest), 1);
  }
}
