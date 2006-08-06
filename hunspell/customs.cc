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

/* Custom bindings */

#include "hunspell.h"

VALUE hunspell_suggest(VALUE self, VALUE word) {
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

VALUE hunspell_analyze(VALUE self, VALUE word) {
  Hunspell *ptr;
  Data_Get_Struct(self, Hunspell, ptr);

  char **output = NULL;
  int ns = ptr->analyze(&output, STR2CSTR(word));
  
  VALUE rubyoutput = rb_ary_new2(ns);
  for ( int i = 0; i < ns; i++ ) {
    rb_ary_push(rubyoutput, rb_str_new2(output[i]));
    free(output[i]);
  }
  free(output);
  
  return rubyoutput;
}
