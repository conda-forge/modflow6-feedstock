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
