#!/bin/bash
set -ex

export FC=gfortran

BUILD_DIR="${SRC_DIR}/builddir"

# configure
meson setup \
	${BUILD_DIR} \
	${SRC_DIR} \
	--prefix ${PREFIX} \
	--libdir "lib" \
	-Ddebug=false

# build & install
meson install -C ${BUILD_DIR}
