@REM 自动获取软件包，提交到SVN
@REM  请不要删除空行
@REM 判断模块数，不能大于10，超出抛错出来！待写！
@REM 


set Mode-num=20
set filename=D:\bash\version\%1\version.txt

@REM *** get label and lable path ***** 
SETLOCAL ENABLEDELAYEDEXPANSION
set k=0


for /f "delims=" %%a in (%filename%) do (
set /a k+=1
echo !k!
if !k! LEQ %Mode-num%  set %%a


)

set k=0
for /f "tokens=1-2 delims==" %%i in (%filename%) do (

set /a k+=1
echo  !k!


find "10.10.5.166" %%j
if "%errorlevel%"=="0"   goto endoff

find "10.10.5.165" "%%j"
if "%errorlevel%"=="0"   goto endoff
find "10.10.5.52" "%%j"
if "%errorlevel%"=="0"  goto endoff


echo 请确认%%i的地址是否来自10.10.5.166或者10.10.5.165或者10.10.5.52

:endoff


)

:endsuccess

echo  OK！
pause




















