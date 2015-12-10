set SRCPATH=%1
set mdl_flag=%2
@REM *** get time  date_value***** 

set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 

@REM *** get svn_version***** 
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
cd/d %SRCPATH%
copy AndroidManifest.xml   AndroidManifest.txt
@REM *** geto  software version***** 
FINDSTR /N "android:versionName"  AndroidManifest.txt  >%SRCPATH%\output\new.txt
SETLOCAL ENABLEDELAYEDEXPANSION
set k=0
for /f "tokens=2" %%i in (%SRCPATH%\output\new.txt) do (
set /a k+=1
if !k!==1   set  lable1=%%i
)
echo %lable1%>%SRCPATH%\output\version.txt
rem del  %SRCPATH%\output\new.txt
rem del   %SRCPATH%\AndroidManifest.txt


SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1-2 delims==" %%i in (%SRCPATH%\output\version.txt) do (
set version=%%~j
)

echo %version% 
rem del  %SRCPATH%\output\version.txt

@REM *** get  file evalue***** 
set output_value=%mdl_flag%_V%version%_svn.%b%_%date_value%


del /f /s /q %SRCPATH%\report\*.xml

call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt



cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *
