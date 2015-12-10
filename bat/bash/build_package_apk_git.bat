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
del  %SRCPATH%\output\new.txt
del   %SRCPATH%\AndroidManifest.txt



SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1-2 delims==" %%i in (%SRCPATH%\output\version.txt) do (
set version=%%~j
)

echo %version% 
del  %SRCPATH%\output\version.txt




@REM *** get  file evalue***** 
set output_value=%mdl_flag%_V%version%_git.%gitversion%_%date_value%


call F:\tools\diffcount\diffcount.exe -c  %SRCPATH% > %SRCPATH%\output\codeline.txt
cd/d %SRCPATH%
echo %SRCPATH%   version:>> output\codeline.txt
call git rev-parse HEAD >> output\codeline.txt

pause



cd/d %SRCPATH%\output
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %output_value%.rar 
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %output_value%.zip *
