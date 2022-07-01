#!/bin/bash
set -ex

BUILD_DIR="${SRC_DIR}/builddir"

# configure
meson setup \
	${BUILD_DIR} \
	${SRC_DIR} \
	--prefix ${PREFIX} \
	--libdir "lib"

# build & install
meson install -C ${BUILD_DIR}
