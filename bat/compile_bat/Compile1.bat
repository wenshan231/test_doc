@echo off
echo *************************************************************************
echo *                          编译并检查测试文件                           *
echo *************************************************************************

echo 各参数信息：
echo 1.产品型号：  %1
echo 2.测试包文件名称：  %2
echo 3.源代码类型：  %3
echo 4.源代码标签：  %4
echo 5.源代码路径：  %5

:: 设置变量
set TMPPATH=E:\DVB\DATA\Tmp_Data
set PRODUCT=%1
set FILENAME=%2
set SRCTYPE=%3
set SRCLABEL=%4
set SRCPATH=%5

E:
for /f "eol=# tokens=1,2,3 delims= " %%a in (E:\DVB\bat\compile_bat\product_type.txt) do (
if %%a==%PRODUCT% (
set TYPE=%%b
set BATPATH=%%c
)
)
echo 编译类型为：%TYPE%
echo 编译路径为：%BATPATH%

for /f "delims=\,tokens=1" %%a in ("%BATPATH%") do set dr=%%a
%dr%
cd %BATPATH%

REM Start Compiling
goto %TYPE%

REM ************************N9202***********************************
:N9202
echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo path=%SRCPATH% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err



echo 现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\LINUX下对应工程查看或者向CMO获取！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\linux\linux_make1.sh"
echo 在linux中编译完成，已退出linux系统！


cd "%BATPATH%\%PRODUCT%\%SRCPATH%\release2test"
REM *检查filelist.txt是否存在！*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\%PRODUCT%\%SRCPATH%\filelist.txt" (
set m=0
set CHECKPATH="%BATPATH%\%PRODUCT%\%SRCPATH%"
)
if exist "%BATPATH%\%PRODUCT%\filelist.txt" (
set m=0
set CHECKPATH="%BATPATH%\%PRODUCT%"
)
if %m% ==1 (
echo 指定路径或Release2Test包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*

echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\%PRODUCT%\%SRCPATH%\Release2Test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\%PRODUCT%\%SRCPATH%\Release2Test！
goto out_err
)
goto end


:end
call E:\DVB\bat\filescheck\filescheck.bat %CHECKPATH% %TMPPATH%\%FILENAME%
REM 调用filescheck.bat时的参数：filetxt的地址  需检查路径
if %fc_result% == 1 goto out_err
REM Compile completed
exit 0

:out_err
exit 1



