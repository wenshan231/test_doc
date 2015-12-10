@REM set initial variable
@REM parameter
@echo 		******************************************************
@echo 		          DHM2.0 UIDIF automake
@echo 		         Written by qiaoting on 2012.04.20
@echo 		******************************************************
@REM parameter
@REM %1---workspace---work.dir_value
@REM %2---模块名称

D:

set SRCPATH=%1
set PRJ=%2
set packspace=%3

echo 

@REM *** getout time  date_value***** 

set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 

@REM *** getout git_version***** 
cd/d %SRCPATH%
call git rev-parse HEAD >> gitversion.txt
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1" %%i in (%SRCPATH%\gitversion.txt) do (
set b=%%i
del  gitversion.txt
)

set gitversion=%b:~0,8%

:tcopy


if exist %SRCPATH%\%packspace%\*.tar.gz    goto zippackspace

echo %SRCPATH%\%packspace%\不存在
exit 1



:zippackspace

cd/d  %SRCPATH%
set output_value=%PRJ%_git.%gitversion%_%date_value%


cd/d %SRCPATH%\%packspace%
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *.tar.gz

exit 0
echo 没有生成tar.gz包！请确认原因！
exit 1 
