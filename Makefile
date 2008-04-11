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
VISIBILITY_CFLAGS = -fvisibility=hidden -DHAVE_VISIBILITY=1
else
VISIBILITY_CFLAGS = -DHAVE_VISIBILITY=0
endif

FINAL_CXXFLAGS = -Wundef $(CXXFLAGS) $(VISIBILITY_CFLAGS) $(HUNSPELL_CFLAGS) $(RUBY_CFLAGS) $(RUST_CFLAGS)
FINAL_LIBS = $(RUBY_LIBS) $(HUNSPELL_LIBS)

PACKAGE = ruby-hunspell

ifeq "$(VERSION)" ""
VERSION = $(shell date +"%Y-%m-%d_%H-%M")
endif

EXTENSIONS_DIR = hunspell
EXTENSIONS = hunspell.so #parsers.so

_EXTENSIONS = $(addprefix $(EXTENSIONS_DIR)/,$(EXTENSIONS))
_EXTENSIONS_SOURCES = $(patsubst %.so,%.cc,$(_EXTENSIONS))
_EXTENSIONS_HEADERS = $(patsubst %.so,%.hh,$(_EXTENSIONS))
_EXTENSIONS_RUSTSRC = $(patsubst %.so,%.rb,$(_EXTENSIONS))

all: $(_EXTENSIONS)

#test: all tests/textparser.rb
#	$(RUBY) -I hunspell tests/textparser.rb

clean:
	-rm $(_EXTENSIONS) $(_EXTENSIONS_SOURCES) $(_EXTENSIONS_HEADERS)
#	-rm hunspell/parsers.cc hunspell/parsers.hh hunspell/parsers.so

dist: $(PACKAGE)-$(VERSION).tar.bz2

install: all
	$(INSTALL) -d $(DESTDIR)$(RUBY_ARCH_DIR)
#	$(INSTALL) -d $(DESTDIR)$(RUBY_ARCH_DIR)/hunspell
	$(INSTALL) hunspell/hunspell.so $(DESTDIR)$(RUBY_ARCH_DIR)
#	$(INSTALL) hunspell/parsers.so $(DESTDIR)$(RUBY_ARCH_DIR)

$(_EXTENSIONS_HEADERS): %.hh: %.cc

$(_EXTENSIONS_SOURCES): %.cc: %.rb
	$(RUBY) -C $(dir $@) $(RUST_RUBYFLAGS) $(notdir $<)

$(_EXTENSIONS): %.so: %.cc
	$(CXX) -shared -fPIC $(FINAL_CXXFLAGS) $(LDFLAGS) $< $(FINAL_LIBS) -o $@

$(PACKAGE)-$(VERSION).tar.bz2: $(shell git ls-files)
	git archive --format=tar --prefix=$(PACKAGE)-$(VERSION)/ HEAD | bzip2 > $@

.PHONY: all install test dist

.PRECIOUS: $(_EXTENSIONS_SOURCES) $(_EXTENSIONS_HEADERS)
