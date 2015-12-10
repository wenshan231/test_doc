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
set filename=%SRCPATH%\build.properties
echo 





@REM *** getmodel_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION
set k=0
for /f "delims=" %%a in (%filename%) do (
set /a k+=1
if !k!==1 set lable1=%%a
if !k!==2 set lable2=%%a
if !k!==3 set lable3=%%a
if !k!==4 set lable4=%%a
if !k!==5 set lable5=%%a
if !k!==6 set lable5=%%a
)
set %lable1%
set  %lable2%
set  %lable3%
set  %lable4%
set  %lable5%
set  %lable6%

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
echo %webapp.version%
pause
set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 
set output_value=%webapp.version%_svn.%b%_%date_value%
if "%webapp.version%"==""  set output_value=%app.version%_svn.%b%_%date_value%



del /f /s /q %SRCPATH%\report\*.xml

call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt



cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *

)
