:: meson options
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  -Ddebug=false ^
 ^"

set "BUILD_DIR=%SRC_DIR%\builddir"

:: configure
meson setup %MESON_OPTIONS% %BUILD_DIR% %SRC_DIR%
if errorlevel 1 (
  type %BUILD_DIR%\meson-logs\meson-log.txt
  exit 1
)

:: build
meson compile -C %BUILD_DIR% -j %CPU_COUNT%
if errorlevel 1 exit 1

:: test (run one example)
pushd examples\ex-gwf-twri01
%BUILD_DIR%\src\mf6.exe
if errorlevel 1 (
  dir
  type mfsim.nam
  type mfsim.lst
  dumpbin /dependents %BUILD_DIR%\src\mf6.exe
  exit 1
)
popd

:: install
meson install -C %BUILD_DIR%
if errorlevel 1 exit 1

:: mf5to6 is a separate meson project and is not reached by the top-level
:: meson.build, so it is configured, built, and installed on its own
set "MF5TO6_BUILD_DIR=%SRC_DIR%\builddir_mf5to6"

meson setup %MESON_OPTIONS% %MF5TO6_BUILD_DIR% %SRC_DIR%\utils\mf5to6
if errorlevel 1 (
  type %MF5TO6_BUILD_DIR%\meson-logs\meson-log.txt
  exit 1
)

meson compile -C %MF5TO6_BUILD_DIR% -j %CPU_COUNT%
if errorlevel 1 exit 1

meson install -C %MF5TO6_BUILD_DIR%
if errorlevel 1 exit 1
