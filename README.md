# Conda Recipes

Three conda recipes demonstrating cross-platform package builds (Windows + Linux) with C/C++ compilation and external dependencies.

## Packages

### libjpeg-turbo
SIMD-accelerated JPEG codec library (C, MMX/SSE2/AVX2/NASM).

- **Windows**: MSVC via `vswhere` + Ninja, NASM for SIMD assembly
- **Linux**: GCC from conda-forge, Ninja, NASM
- Uses `run_exports` for automatic dependency pinning downstream

### monado
Open source OpenXR runtime (C/C++).

- **Windows**: vcpkg for dependency management (Vulkan, SDL2, Eigen3, hidapi, libusb, cJSON, pthreads), cloned at a pinned commit for reproducibility
- **Linux**: all dependencies from conda-forge host environment
- Compiler macros restricted to Unix (`# [unix]`) — vcpkg handles toolchain on Windows

### python-rapidjson
Python wrapper around RapidJSON (C++ extension).

- Bundles RapidJSON as a second source entry (no submodule required)
- Uses `{{ compiler('cxx') }}` on all platforms — Python in host prevents the empty-package error
- Built with `pip install --no-deps`

## Building

```bash
# Linux
conda build <package>/conda-recipe/ -c conda-forge

# Windows
conda build <package>/conda-recipe/
```

## Requirements

- `conda-build`
- Windows: Visual Studio 2019 or 2022, Vulkan SDK (optional for monado)
- Linux: conda-forge channel
