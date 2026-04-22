@echo off
setlocal

set "VCPKG_DIR=%SRC_DIR%\vcpkg"
set "TOOLCHAIN=%VCPKG_DIR%\scripts\buildsystems\vcpkg.cmake"

if not exist "%VCPKG_DIR%\bootstrap-vcpkg.bat" (
    echo Cloning vcpkg...
    git clone https://github.com/microsoft/vcpkg.git "%VCPKG_DIR%"
    if errorlevel 1 exit 1
    git -C "%VCPKG_DIR%" checkout 4334d8b4c8916018600212ab4dd4bbdc343065d1
    if errorlevel 1 exit 1
)

if not exist "%VCPKG_DIR%\vcpkg.exe" (
    echo Bootstrapping vcpkg...
    call "%VCPKG_DIR%\bootstrap-vcpkg.bat" -disableMetrics
    if errorlevel 1 exit 1
)

if exist build_conda rmdir /s /q build_conda
mkdir build_conda
cd build_conda

set "VULKAN_SDK_FLAG="
if defined VULKAN_SDK set "VULKAN_SDK_FLAG=-DVULKAN_SDK=%VULKAN_SDK%"

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%PREFIX%" ^
    -DCMAKE_TOOLCHAIN_FILE="%TOOLCHAIN%" ^
    -DVCPKG_MANIFEST_MODE=ON ^
    -DVCPKG_MANIFEST_DIR="%SRC_DIR%" ^
    -DXRT_FEATURE_SERVICE=ON ^
    -DXRT_MODULE_IPC=ON ^
    -DBUILD_DOC=OFF ^
    -DXRT_HAVE_OPENCV=OFF ^
    -DXRT_HAVE_FFMPEG=OFF ^
    -DXRT_HAVE_LIBUVC=OFF ^
    %VULKAN_SDK_FLAG% ^
    ..
if errorlevel 1 exit 1

cmake --build . --parallel %CPU_COUNT%
if errorlevel 1 exit 1

cmake --install .
if errorlevel 1 exit 1
