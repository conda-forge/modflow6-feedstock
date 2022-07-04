setlocal EnableDelayedExpansion
@echo on

:: meson options
:: (set pkg_config_path so deps in host env can be found)
set ^"MESON_OPTIONS=^
  --prefix="%LIBRARY_PREFIX%" ^
  -Ddebug=false ^
 ^"

:: configure build using meson
meson setup builddir !MESON_OPTIONS!
if errorlevel 1 exit 1

meson install -C builddir
if errorlevel 1 exit 1
