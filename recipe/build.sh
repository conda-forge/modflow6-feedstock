#!/bin/bash
set -ex

BUILD_DIR="${SRC_DIR}/builddir"

# configure
meson setup \
    ${MESON_ARGS} \
    --prefix ${PREFIX} \
    --libdir "lib" \
    -Ddebug=false \
    ${BUILD_DIR} ${SRC_DIR}

# build
meson compile -C ${BUILD_DIR} -j ${CPU_COUNT}

# install
meson install -C ${BUILD_DIR}
