#!/bin/bash
set -ex

BUILD_DIR="${SRC_DIR}/build"

# configure
meson setup \
	${BUILD_DIR} \
	${SRC_DIR} \
	--prefix ${PREFIX} \
	--libdir "lib"
pushd ${BUILD_DIR}

# build
ninja -j ${CPU_COUNT} all

# check
# ninja test

# install
ninja install
