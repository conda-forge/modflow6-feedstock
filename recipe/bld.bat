:: install intel fortran ifort
set URL=https://registrationcenter-download.intel.com/akdlm/irc_nas/18857/w_HPCKit_p_2022.3.0.9564_offline.exe
set COMPONENTS=intel.oneapi.win.ifort-compiler
curl --output %TEMP%\webimage.exe --url %URL%  --retry 5 --retry-delay 5
start /b /wait %TEMP%\webimage.exe -s -x -f %TEMP%\webimage_extracted --log %TEMP%\extract.log
del %TEMP%\webimage.exe
%TEMP%\webimage_extracted\bootstrapper.exe -s --action install --components=%COMPONENTS% --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=%TEMP%
call "C:\Program Files (x86)\Intel\oneAPI\setvars.bat" intel64 vs2022
where ifort
set FC=ifort

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
