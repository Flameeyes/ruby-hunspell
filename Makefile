HUNSPELL_CFLAGS = $(shell pkg-config --cflags hunspell)
HUNSPELL_LIBS = $(shell pkg-config --libs hunspell)

ifneq "$(RUSTDIR)" ""
RUST_CFLAGS = -I$(RUSTDIR)/include
RUST_RUBYFLAGS = -I$(RUSTDIR)
else
RUST_CFLAGS =
RUST_RUBYFLAGS =
endif

INSTALL = install

RUBY = ruby
RUBY_ARCH_DIR = $(shell $(RUBY) -r rbconfig -e 'printf("%s",Config::CONFIG["archdir"])')
RUBY_CFLAGS = -I$(RUBY_ARCH_DIR)
RUBY_LIBS = $(shell $(RUBY) -r rbconfig -e 'printf("%s",Config::CONFIG["LIBRUBYARG_SHARED"])')

USE_VISIBILITY = $(shell $(CPP) -E -P extra/visibility-test.c | grep YES)

ifeq "$(USE_VISIBILITY)" "YES"
VISIBILITY_CFLAGS = -fvisibility=hidden
endif

FINAL_CFLAGS = $(CFLAGS) $(VISIBILITY_CFLAGS) $(HUNSPELL_CFLAGS) $(RUBY_CFLAGS) $(RUST_CFLAGS)

all: hunspell/hunspell.so #hunspell/parsers.so

#test: all tests/textparser.rb
#	$(RUBY) -I hunspell tests/textparser.rb

install: all
	$(INSTALL) -d $(DESTDIR)$(RUBY_ARCH_DIR)
	$(INSTALL) -d $(DESTDIR)$(RUBY_ARCH_DIR)/hunspell
	$(INSTALL) hunspell/hunspell.so $(DESTDIR)$(RUBY_ARCH_DIR)
	$(INSTALL) hunspell/parsers.so $(DESTDIR)$(RUBY_ARCH_DIR)

hunspell/%.hh: hunspell/%.cc

hunspell/%.cc: hunspell/%.rb
	$(RUBY) -Chunspell $(RUST_RUBYFLAGS) $(notdir $<)

hunspell/%.so: hunspell/%.cc
	$(CC) -shared -fPIC $(FINAL_CFLAGS) $(LDFLAGS) $< $(RUBY_LIBS) -o $@

.PHONY: all install test

.PRECIOUS: hunspell/%.cc hunspell/%.hh
