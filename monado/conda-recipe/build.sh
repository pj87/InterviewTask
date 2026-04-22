#!/bin/bash
set -euxo pipefail

rm -rf build_conda
mkdir -p build_conda
cd build_conda

cmake -G "Ninja" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
    -DXRT_FEATURE_SERVICE=ON \
    -DXRT_MODULE_IPC=ON \
    -DBUILD_DOC=OFF \
    -DXRT_HAVE_OPENCV=OFF \
    -DXRT_HAVE_FFMPEG=OFF \
    ..

cmake --build . --parallel ${CPU_COUNT}
cmake --install .
