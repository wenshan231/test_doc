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

rem getout svn_version
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

set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 


rem###############get software version##############
cd/d %SRCPATH%
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



set output_value=%mdl_flag%_%version%_svn.%b%_%date_value%


del /f /s /q %SRCPATH%\report\*.xml

call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt



cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *

)
