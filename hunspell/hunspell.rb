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

word_in_array_out_prototype = "VALUE !function_varname!(VALUE self, VALUE word)\n"
word_in_array_out_stub = 
  "VALUE !function_varname!(VALUE self, VALUE word) {
    ::Hunspell* ptr = ruby2Hunspell_HunspellPtr(self);
    if ( ! ptr ) return Qnil; /* The exception is thrown by ruby2* */
  
    char **output = NULL;
    int ns = ptr->!function_cname!(&output, STR2CSTR(word));
    
    VALUE rubyoutput = rb_ary_new2(ns);
    for ( int i = 0; i < ns; i++ ) {
      rb_ary_push(rubyoutput, rb_str_new2(output[i]));
      free(output[i]);
    }
    free(output);
    
    return rubyoutput;
  }"

Rust::Bindings::create_bindings Rust::Bindings::LangCxx, "hunspell" do |b|
  b.include_header 'hunspell.hxx', Rust::Bindings::HeaderGlobal

  b.add_namespace "Hunspell", "" do |ns|
    ns.add_cxx_class "Hunspell" do |klass|
      klass.add_constructor do |method|
        method.add_parameter "char *", "affpath"
        method.add_parameter "char *", "dpath"
      end

      klass.add_method "spell", "bool" do |method|
        method.add_parameter "char *", "word"
      end

      klass.add_method "suggest" do |method|
        method.add_parameter "char *", "word"

        method.set_custom(word_in_array_out_prototype,
                          word_in_array_out_stub)
      end

      klass.add_method "put_word" do |method|
        method.add_parameter "char *", "word"
      end

      klass.add_method "put_word_suffix" do |method|
        method.add_parameter "char *", "word"
        method.add_parameter "char *", "suffix"
      end

      klass.add_method "put_word_pattern" do |method|
        method.add_parameter "char *", "word"
        method.add_parameter "char *", "pattern"
      end

      # Other functions
      klass.add_method "get_dic_encoding", "char *"

      klass.add_method "get_wordchars", "const char *"

      # Missing: get_wordchars_utf16
      # Missing: get_csconv
      # Missing: get_utf_conv

      klass.add_method "get_version", "char *"

      # Morphological analysis
      klass.add_method "morph" do |method|
        method.add_parameter "char *", "word"
      end

      klass.add_method "analyze" do |method|
        method.add_parameter "char *", "word"

        method.set_custom(word_in_array_out_prototype,
                          word_in_array_out_stub)
      end

      klass.add_method "morph_with_correction" do |method|
        method.add_parameter "char *", "word"
      end

      # Stemmer function
      klass.add_method "stem" do |method|
        method.add_parameter "char *", "word"

        method.set_custom(word_in_array_out_prototype,
                          word_in_array_out_stub)
      end

      # Spec. suggestion
      klass.add_method "suggest_auto" do |method|
        method.add_parameter "char *", "word"

        method.set_custom(word_in_array_out_prototype,
                          word_in_array_out_stub)
      end

      klass.add_method "suggest_pos_stems" do |method|
        method.add_parameter "char *", "word"

        method.set_custom(word_in_array_out_prototype,
                          word_in_array_out_stub)
      end

    end
  end
end
