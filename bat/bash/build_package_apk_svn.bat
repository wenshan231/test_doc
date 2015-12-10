@REM set initial variable
@REM %1---workspace---work.dir_value
@REM %2---模块名称

D:

set SRCPATH=%1
set PRJ=%2
set packspace=%3

echo  

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
if %%i equ %1 echo.%%j&set b=%%j)

set filename=%PRJ%_svn.%b%_%date_value%
echo %filename%

if exist %packspace%\*.apk    goto zippackspace

echo %packspace%\*.apk\不存在
exit 1

:zippackspace


cd/d %packspace%
rem call "C:\Program Files\WinRAR\WinRAR.exe" a -r -df  %filename%.rar *
call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %filename%.zip *

exit 0
echo 没有生成.apk文件！请确认原因！
exit 1 
