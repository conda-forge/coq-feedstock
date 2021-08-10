#!/bin/bash

sed -i.bak "s/CODESIGN=.*/CODESIGN=true/g" Makefile.build
export LIBRARY_PATH=$PREFIX/lib
export DYLD_FALLBACK_LIBRARY_PATH=$PREFIX/lib

./configure -prefix=$PREFIX

chmod +w config/coq_config.ml
sed "s@\"${OCAML_PREFIX}/@(Sys.getenv \"OCAML_PREFIX\") ^ \"/@g" config/coq_config.ml > config/coq_config.ml.bak
sed "s@\"file:/${OCAML_PREFIX}/@\"file:/\" ^ (Sys.getenv \"OCAML_PREFIX\") ^ \"/@g" config/coq_config.ml.bak > config/coq_config.ml
cat config/coq_config.ml

if [[ "$target_platform" == osx-64 ]]; then
  make -j${CPU_COUNT} || true
  $INSTALL_NAME_TOOL -add_rpath $PREFIX/lib $PWD/bin/ocamllibdep
  $OTOOL -l $PWD/bin/ocamllibdep
fi

make -j${CPU_COUNT}
make install
