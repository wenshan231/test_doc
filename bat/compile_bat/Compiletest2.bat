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

REM ******************CDVB***************************************
:CDVB

if %PRODUCT% == CDVBC5600I (
echo 临时调整，产品CDVB5600I自动编译有问题，需手动处理！
goto out_err
)

if %SRCTYPE%==SVN (
cd %BATPATH%
cd ..
rmdir src /S/Q
echo 从SVN中获取代码：
svn export %SRCLABEL% src
)

cd %BATPATH%
attrib -r /s
REM *检查filelist.txt是否存在！*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\test\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\test
)
if %m% ==1 (
echo 指定路径或test包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*
echo 现在开始编译！
call Autobuild.bat
echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\test" "%TMPPATH%\%FILENAME%\" /s/e/y
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\test！
goto out_err
)
goto end

REM ********************UPI****************************************
:UPI
cd %BATPATH%
for /f "tokens=2 delims=\" %%a in ("%BATPATH%") do (
set SUBPATH=%%a
)

cd ..
rmdir %SUBPATH% /S/Q
svn co %SRCLABEL% %SUBPATH%
cd %SUBPATH%
cd %SRCPATH%

set buildpath=%cd%
if not "%SRCPATH%"=="/" ( 
if "%buildpath%"=="%BATPATH%" goto out_err
)

REM *检查filelist.txt是否存在！*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%buildpath%
)
if exist "%BATPATH%\output\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\output
)
if %m% ==1 (
echo 指定路径或output包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*

call build.bat
echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\output" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\output！
goto out_err
)
goto end

REM ********************HMC****************************************
:HMC
echo taglable=%SRCLABEL% > %BATPATH%\colable
if errorlevel 1 goto out_err
for /f "delims=/ tokens=1*" %%a in ("%SRCPATH%") do (
echo prj1=%%a >>  %BATPATH%\colable
if errorlevel 1 goto out_err
set prj1=%%a
echo prj2=%%b >>  %BATPATH%\colable
if errorlevel 1 goto out_err
set prj2=%%b
)

echo 现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\hmc2下对应工程查看或者向CMO获取！
call putty.exe root@10.10.98.188 -pw coship -m "E:\DVB\bat\compile_bat\hmc\make.sh"
echo 在linux中编译完成，已退出linux系统！
k:
cd %BATPATH%\%prj1%\product\%prj1%\%prj2%

REM *检查filelist.txt是否存在！*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test
)
if %m% ==1 (
echo 指定路径或release2test包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*

echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test！
goto out_err
)
goto end

REM ********************BCM****************************************
:BCM

cd %BATPATH%\src
REM *检查filelist.txt是否存在！*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\src\release\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\src\release
)
if %m% ==1 (
echo 指定路径或release包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*

echo pro=%PRODUCT% > y:\colable

echo 现在进入linux中编译，现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\下对应工程查看或者向CMO获取！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\test.sh" 
echo 在linux中编译完成，已退出linux系统！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
y:
cd %BATPATH%\src\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\src\release" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\src\release！
goto out_err
)
goto end

REM ************************LINUX***********************************
:LINUX
echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo path=%SRCPATH% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err



echo 现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\LINUX下对应工程查看或者向CMO获取！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\linux\linux_make.sh"
echo 在linux中编译完成，已退出linux系统！


cd "%BATPATH%\%PRODUCT%\release2test"
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
echo 指定路径或release2test包中未提供filelist，请更新后再提交自动编译！
goto out_err
)
REM *检查完毕！*

echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\%PRODUCT%\release2test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\%PRODUCT%\release2test！
goto out_err
)
goto end

REM ********************svn_bcm****************************************
:svn_bcm

echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
y:
echo 现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\hmc2下对应工程查看或者向CMO获取！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\N9201uspmake.sh"

cd %BATPATH%\%PRODUCT%
if not exist filelist.txt (
echo there is no filelist
goto out_err
)

Y:
cd %BATPATH%\%PRODUCT%\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
echo 编译完成，复制测试文件到临时打包路径
xcopy "%BATPATH%\%PRODUCT%\release" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\%PRODUCT%\release！
goto out_err
)
goto end


REM *************
:end
call E:\DVB\bat\filescheck\filescheck.bat %CHECKPATH% %TMPPATH%\%FILENAME%
REM 调用filescheck.bat时的参数：filetxt的地址  需检查路径
if %fc_result% == 1 goto out_err
REM Compile completed
exit 0

:out_err
rem 发通知邮件
e:
cd E:\DVB\bat\compile_bat
call complie_email_error.vbs %1 %2 %3 %4 %5
exit 1



if [ "$prj1" == "/" ]
then
echo 路径为"/"是非法路径,请修改重新提交> $prjpath/$prj1/makelog 2>&1
exit
fi