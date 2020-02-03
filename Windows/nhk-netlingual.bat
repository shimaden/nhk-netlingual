@echo off
setlocal
set PATH=%~dp0system\bin;%PATH%

if %~x0 == .exe ( shift )
ruby.exe -rneri  --disable-gems --disable-did_you_mean -e "# coding:utf-8" -e "Neri.datafile='%~dp0system/' + [110,104,107,45,110,101,116,108,105,110,103,117,97,108,46,100,97,116].pack('U*');load File.expand_path([110,104,107,45,110,101,116,108,105,110,103,117,97,108,46,114,98].pack('U*'))"  %1 %2 %3 %4 %5 %6 %7 %8 %9
echo.
pause
endlocal
