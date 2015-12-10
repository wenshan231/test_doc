@REM set initial variable
@REM parameter
@echo 		******************************************************
@echo 		          DHM2.0 UIDIF automake
@echo 		         Written by qiaoting on 2012.04.20
@echo 		******************************************************
@REM parameter
@REM %1---workspace---work.dir_value
@REM %2---Ä£¿éÃû³Æ

D:

set SRCPATH=%1
set mdl_flag=%2
echo 
if exist %SRCPATH%\output   goto zipoutput

echo %SRCPATH%\output  not  exist
exit 1
:zipoutput

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

set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 


rem###############get software version##############
cd/d %SRCPATH%
del  pom.txt
del  1.txt
copy pom.xml   pom.txt

SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1-5 delims=<>" %%i in (pom.txt) do (

echo %%j=%%k>>1.txt

)
for /f "tokens=1-2 delims==" %%i in (1.txt) do (
if %%i==version set version=%%j&goto echover)

)


:echover
echo %version%




set output_value=%mdl_flag%_%version%_git.%gitversion%_%date_value%


del /f /s /q %SRCPATH%\report\*.xml

call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt

cd/d %SRCPATH%
echo %SRCPATH%   version:>> output\codeline.txt
call git rev-parse HEAD >> output\codeline.txt



cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *

)
