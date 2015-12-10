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

@REM *** getout svn_version***** 
set var=11
set ff=%SRCPATH%\.svn\entries
for %%a in (%var%) do (
call :lp %%a
)
goto :eof
:lp
for /f "tokens=1,* delims=:" %%i in ('findstr/n .* %ff%') do (
if %%i equ %1 echo.%%j&set b=%%j&goto tcopy)

:tcopy

if exist %SRCPATH%\output\software\*.tar.gz    goto zipsoftoutput
if exist %SRCPATH%\output    goto zipoutput

if exist %SRCPATH%\integration\*.tar.gz    goto zipintegration

echo %SRCPATH%\output 或者%SRCPATH%\integration不存在
exit 1

:zipoutput

dir /b %SRCPATH%\output\*.tar.gz  >>%SRCPATH%\output\list.txt
dir /b %SRCPATH%\output\*.jar  >>%SRCPATH%\output\list.txt
cd /d %SRCPATH%\output
@REM *** get output  model_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1 delims=." %%i in (%SRCPATH%\output\list.txt) do (
set version=%%i
del  list.txt
)

echo %version%
pause

set output_value=%version%_svn.%b%_%date_value%
if "%version%"==""  goto versionerror

del /f /s /q %SRCPATH%\report\*.xml
call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt


cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *
exit 0


:zipsoftoutput

dir /b %SRCPATH%\output\software\*.tar.gz  >%SRCPATH%\output\software\list.txt

cd/d%SRCPATH%\output\software
@REM *** get output  model_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1 delims=." %%i in (%SRCPATH%\output\software\list.txt) do (
set version=%%i
del  list.txt
)

echo %version%
pause

set output_value=%version%_svn.%b%_%date_value%
if "%version%"==""  goto versionerror

del /f /s /q %SRCPATH%\report\*.xml
call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt


cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *
exit 0

:zipintegration

dir /b %SRCPATH%\integration\*.tar.gz > %SRCPATH%\integration\list.txt

cd/d %SRCPATH%\integration
@REM *** get output  model_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1 delims=." %%i in (%SRCPATH%\integration\list.txt) do (
set version=%%i
del  list.txt
)

echo %version%
pause

set output_value=%version%_svn.%b%_%date_value%
if "%version%"==""  goto versionerror

del /f /s /q %SRCPATH%\report\*.xml
call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\integration\codeline.txt


cd/d %SRCPATH%\integration
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *.tar.gz codeline.txt

exit 0


:versionerror
echo 没有生成tar.gz包！请确认原因！
exit 1 
