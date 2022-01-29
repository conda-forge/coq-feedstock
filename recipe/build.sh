#!/bin/bash

sed -i.bak "s/CODESIGN=.*/CODESIGN=true/g" Makefile.build
sed -i.bak 's/$(LINKMETADATA)/$(LINKMETADATA) '"-cclib -L$PREFIX/lib -cclib -Wl,-rpath,$PREFIX/lib" Makefile.build
export LIBRARY_PATH=$PREFIX/lib
export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib

./configure -prefix=$PREFIX

chmod +w config/coq_config.ml
sed "s@\"${OCAML_PREFIX}/@(Sys.getenv \"OCAML_PREFIX\") ^ \"/@g" config/coq_config.ml > config/coq_config.ml.bak
sed "s@\"file:/${OCAML_PREFIX}/@\"file:/\" ^ (Sys.getenv \"OCAML_PREFIX\") ^ \"/@g" config/coq_config.ml.bak > config/coq_config.ml
cat config/coq_config.ml

make -j${CPU_COUNT}
make install
