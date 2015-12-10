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


if exist %SRCPATH%\integration\*.tar.gz    goto zipintegration

echo %SRCPATH%\integration不存在
exit 1



:zipintegration

cd/d  %SRCPATH%
@REM *** get output  model_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1-2 delims==" %%i in ( %SRCPATH%\package.sh) do (
if %%i==version set version=%%~j

)

echo %version%

pause





set output_value=%version%_git.%gitversion%_%date_value%
if "%version%"==""  goto versionerror

del /f /s /q %SRCPATH%\report\*.xml
call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\integration\codeline.txt
cd/d %SRCPATH%
echo %SRCPATH%   version:>> integration\codeline.txt
call git rev-parse HEAD >> integration\codeline.txt
echo -------------->> integration\codeline.txt

if exist %SRCPATH%\..\commonsdk    (
echo commonsdk   version:>> integration\codeline.txt
cd ../commonsdk

call git rev-parse HEAD >> %SRCPATH%\integration\codeline.txt
)








cd/d %SRCPATH%\integration
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *.tar.gz codeline.txt

exit 0



:versionerror
echo 没有生成tar.gz包！请确认原因！
exit 1 
