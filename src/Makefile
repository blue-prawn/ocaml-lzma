#  Copyright (C) 2010  Florent Monnier
#  This file is distributed under the terms of the MIT license.
#  See the file LICENSE.txt for more details.

OCAMLC := ocamlc -g
OCAMLOPT := ocamlopt -g
OCAMLMKLIB := ocamlmklib
OCAMLDOC := ocamldoc
OCAMLFIND := ocamlfind
OCAML_PATH := $(shell $(OCAMLC) -where)
LZMA_LIBS := -llzma
LZMA_DIR := lzma
INC_DIR := /usr/include
LIB_DIR := /usr/lib
LZMA_INC := -I$(INC_DIR)
LINK_DIR := -L$(LIB_DIR)
LZMA_LINK := $(LINK_DIR) $(LZMA_LIBS)
PREFIX := $(OCAML_PATH)/$(LZMA_DIR)
SO_PREFIX := $(PREFIX)
#SO_PREFIX := $(OCAML_PATH)/stublibs/
DOC_DIR := doc
RMDIR := rmdir

all: cma cmxa cmxs
byte cma: lzma.cma
opt cmxa: lzma.cmxa
shared cmxs: lzma.cmxs
.PHONY: all byte cma opt cmxa

lzma.mli: lzma.ml
	$(OCAMLC) -i $< > $@

lzma.cmi: lzma.mli
	$(OCAMLC) -c $<

lzma.cmx: lzma.ml lzma.cmi
	$(OCAMLOPT) -c $<

lzma.cmo: lzma.ml lzma.cmi
	$(OCAMLC) -c $<

lzma_stubs.o: lzma_stubs.c
	$(OCAMLC) -c -ccopt "$(LZMA_INC)" $<

liblzma_stubs.a: lzma_stubs.o
	$(OCAMLMKLIB) -oc lzma_stubs $< $(LZMA_LINK)

lzma.cmxa lzma.a: lzma.cmx liblzma_stubs.a
	$(OCAMLMKLIB) -o lzma -ccopt '"$(LZMA_LINK)"' -L. -llzma_stubs $<

lzma.cma: lzma.cmo liblzma_stubs.a
	$(OCAMLC) -a -o $@ -ccopt "$(LZMA_LINK)" -dllib -llzma_stubs $<

lzma.cmxs: lzma.cmxa
	$(OCAMLOPT) -shared -linkall -o $@ $<

.PHONY: doc
doc: lzma.ml lzma.cmi
	mkdir -p $(DOC_DIR)
	$(OCAMLDOC) lzma.ml -colorize-code -html -d $(DOC_DIR)

EDITOR := vim
.PHONY: edit
edit:
	$(EDITOR) lzma.ml lzma_stubs.c

DIST_FILES=           \
    liblzma_stubs.a   \
    lzma.a            \
    lzma.o            \
    lzma.cma          \
    lzma.cmi          \
    lzma.cmo          \
    lzma.cmx          \
    lzma.cmxa         \
    lzma.ml           \
#EOL
SO_DIST_FILES=        \
    dlllzma_stubs.*   \
#EOL
PLUG_DIST_FILES=      \
    lzma.cmxs         \
#EOL

INSTALL_DIR := install -d
INSTALL_FILE := install -m 0644
INSTALL_EXE := install -m 0755

.PHONY: install uninstall
install: $(DIST_FILES)  $(SO_DIST_FILES) META
	if [ ! -d $(PREFIX) ]; then $(INSTALL_DIR) $(PREFIX) ; fi
	for file in $(DIST_FILES);      do if [ -f $$file ]; then $(INSTALL_FILE) $$file $(PREFIX)/; fi; done
	for file in $(SO_DIST_FILES);   do if [ -f $$file ]; then $(INSTALL_EXE)  $$file $(SO_PREFIX)/; fi; done
	for file in $(PLUG_DIST_FILES); do if [ -f $$file ]; then $(INSTALL_EXE)  $$file $(PREFIX)/; fi; done
	$(INSTALL_FILE) META $(PREFIX)/

uninstall:
	$(RM) $(PREFIX)/*
	$(RMDIR) $(PREFIX)/

.PHONY: findinstall
findinstall:
	$(OCAMLFIND) install lzma META *.cma *.cmxa *.cmxs *.cmi *.cmx *.mli *.so *.a

.PHONY: clean cleaner cleanmli cleandoc cleanall
clean:
	$(RM) *.[oa] *.cm[ioxa] *.so *.dll *.cmx[as] *.exe *.opt *.byte
cleaner:
	$(RM) *~
cleanmli:
	$(RM) lzma.mli
cleandoc:
	$(RM) $(DOC_DIR)/*
	$(RMDIR) $(DOC_DIR)

cleanall: clean cleaner cleanmli cleandoc
