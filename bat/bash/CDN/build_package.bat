@REM set initial variable
@REM parameter
@echo 		******************************************************
@echo 		          DHM2.0 UIDIF automake
@echo 		         Written by qiaoting on 2012.04.20
@echo 		******************************************************
@REM parameter
@REM %1---workspace---work.dir_value
@REM %2---Ä£¿éÃû³Æ

Y:
cd %1
if not exist %1  exit 1 

set SRCPATH=%1
set mdl_flag=%2
echo 



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
set output_value=%mdl_flag%_svn.%b%_%date_value%


del /f /s /q %SRCPATH%\report\*.xml

call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\integration\codeline.txt

if not exist %SRCPATH%\integration   exit 1 

cd/d %SRCPATH%\integration
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *.tar.gz codeline.txt

)
