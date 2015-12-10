@echo off
echo ******************************************************************************
echo *		           编译成功，将测试文件打包并上传至测试路径		  *    
echo ******************************************************************************
echo 各参数信息:
echo 测试包名称：%1
echo 测试包VSS库名：%2
echo 测试包路径：%3
echo 备注信息：%4
echo BL软件包名称：%5
echo BL软件包路径：%6
echo 源代码标签：%7
echo 源代码路径：%8

set TMPPATH=E:\DVB\DATA\Tmp_Data

: 判断各参数是否为空

if %1 == "" goto out_err
if %2 == "" goto out_err
if %3 == "" goto out_err
if %4 == "" goto out_err
if %5 == "" goto out_err
if %6 == "" goto out_err
if %7 == "" goto out_err
if %8 == "" goto out_err

if %5 == tmp goto out_bl
e:
cd E:\DVB\bat\bootloader
call bootloader_post_Compile.bat %TMPPATH%\%1 %5 %6
if %BLRESULT% == error (
echo 获取Bootloader软件包失败！
goto out_err
)
:out_bl

e:
cd "%TMPPATH%\%1"
REM 压缩文件
WinRAR a -r -afzip %1.zip

set codetype=vss
set database=%2
set datapath=%3

for /f "tokens=1* delims=:" %%a in ("%7") do set codetype=%%a
echo codetype：%codetype%

if NOT "%codetype%" == "svn" goto vss

for /f "tokens=1* delims=:" %%i in ("%3") do set tpath=%%i

if "%tpath%" == "http" (
svn import -m %4 "%1.zip" %3/"%1.zip"
if %errorlevel% == 1 goto out_err
goto out
) else (
for /f "tokens=1* delims=/" %%x in ("%3") do (
set dbase=%%x
set database=\\192.168.99.101\%%x
set datapath=%%y
)
)

:vss
echo %database%
echo %datapath%

REM add .zip to VSS
set ssdir=%database%
ss cp $/%datapath% -I- -Yluntbuild,luntbuild25
REM 删除文件，避免出现同名文件//如果一天内提交三次测试申请，且每次名称均相同，则会出现问题
ss delete %1.zip -I- -Yluntbuild,luntbuild25
ss add %1.zip -I- -Yluntbuild,luntbuild25 -c%4

:out
echo 提交成功
exit

:out_err
echo 提交失败
K:



rem if %errorlevel% == 0 (
rem for /f "tokens=3 delims=:" %%a in (%4) do set dlname=%%a
rem find "%dlname%"<"E:\DVB\bat\sendmail\国际运营开发人员.txt"
rem if %errorlevel% == 0 (
rem call E:\DVB\bat\sendmail\sendmail.vbs %4已通过自动编译提交测试，请知悉！ 测试软件包：%1.zip
rem )
rem ) else (
rem echo add package is failed
rem goto out_err
rem )