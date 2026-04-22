@echo off
setlocal

set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%VSWHERE%" (
    echo ERROR: vswhere.exe not found. Visual Studio 2017 or later is required.
    exit 1
)
for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -property installationPath`) do set "VS_INSTALL=%%i"
if not defined VS_INSTALL (
    echo ERROR: No Visual Studio installation found.
    exit 1
)
call "%VS_INSTALL%\VC\Auxiliary\Build\vcvars64.bat"
if errorlevel 1 exit 1

if exist build_cmake rmdir /s /q build_cmake
mkdir build_cmake
cd build_cmake

cmake -G "Ninja" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DENABLE_SHARED=TRUE ^
    -DENABLE_STATIC=TRUE ^
    -DWITH_SIMD=TRUE ^
    -DWITH_JPEG8=TRUE ^
    ..
if errorlevel 1 exit 1

cmake --build . --parallel %CPU_COUNT%
if errorlevel 1 exit 1

cmake --install .
if errorlevel 1 exit 1
