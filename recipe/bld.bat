:: Based on scipy-feedstock

:: flang 17 still uses "temporary" name
set "FC=flang-new"

:: attempt to match flags for flang as we set them for clang-on-win, see
:: https://github.com/conda-forge/clang-win-activation-feedstock/blob/main/recipe/activate-clang_win-64.sh
:: however, -Xflang --dependent-lib=msvcrt currently fails as an unrecognized option, see also
:: https://github.com/llvm/llvm-project/issues/63741
set "FFLAGS=-D_CRT_SECURE_NO_WARNINGS -D_MT -D_DLL --target=x86_64-pc-windows-msvc -nostdlib"
set "LDFLAGS=--target=x86_64-pc-windows-msvc -nostdlib -Xclang --dependent-lib=msvcrt -fuse-ld=lld"
set "LDFLAGS=%LDFLAGS% -Wl,-defaultlib:%BUILD_PREFIX%/Library/lib/clang/!CLANG_VER:~0,2!/lib/windows/clang_rt.builtins-x86_64.lib"

:: see explanation here:
:: https://github.com/conda-forge/scipy-feedstock/pull/253#issuecomment-1732578945
set "MESON_RSP_THRESHOLD=320000"

:: meson options
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  -Ddebug=true ^
  -Doptimization=0 ^
 ^"

set "BUILD_DIR=%SRC_DIR%\builddir"

:: configure
meson setup %MESON_OPTIONS% %BUILD_DIR% %SRC_DIR%
if errorlevel 1 exit 1

:: build
meson compile -C %BUILD_DIR% -j %CPU_COUNT%
if errorlevel 1 exit 1

:: test (run one example)
cd examples\ex-gwf-twri01
%BUILD_DIR%\src\mf6.exe
if errorlevel 1 (
  dir
  type mfsim.nam
  type mfsim.lst
  dumpbin /dependents %BUILD_DIR%\src\mf6.exe
  exit 1
)
cd ..\..

:: install
meson install -C %BUILD_DIR%
if errorlevel 1 exit 1
