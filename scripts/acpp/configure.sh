#!/bin/bash

set -e
set -x

~/.pixi/bin/pixi add --manifest-path "$PIXI_PROJECT_MANIFEST" cuda spirv-tools ocl-icd ocl-icd-system zlib llvm-openmp boost

mkdir -p "$PIXI_PROJECT_ROOT"/build

cd "$PIXI_PROJECT_ROOT"/build

cmake .. \
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr/local/acpp \
  -DWITH_OPENCL_BACKEND=ON \
  -DWITH_CUDA_BACKEND=ON \
  -DCMAKE_CXX_COMPILER="$CLANGXX" \
  -DCLANG_EXECUTABLE_PATH="$CLANGXX" \
  -DLLVM_DIR="$CONDA_PREFIX"/lib/cmake/llvm \
  -DCLANG_INCLUDE_PATH="$CONDA_PREFIX"/include/clang
