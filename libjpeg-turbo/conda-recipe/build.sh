#!/bin/bash
set -euxo pipefail

mkdir -p build_cmake
cd build_cmake

cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DCMAKE_INSTALL_LIBDIR="lib" \
    -DENABLE_SHARED=TRUE \
    -DENABLE_STATIC=TRUE \
    -DWITH_SIMD=TRUE \
    -DWITH_JPEG8=TRUE \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    ..

cmake --build . --parallel ${CPU_COUNT}
cmake --install .