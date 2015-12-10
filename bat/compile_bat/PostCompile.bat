@echo off
echo ******************************************************************************
echo *                  编译成功，将测试文件打包并上传至测试路径                  *    
echo ******************************************************************************
echo 各参数信息:
echo 1.测试包名称： %1
echo 2.测试包VSS库名： %2
echo 3.测试包路径： %3
echo 4.备注信息： %4
echo 5.BL软件包名称： %5
echo 6.BL软件包路径： %6
echo 7.源代码标签： %7
echo 8.源代码路径： %8
echo 9.公司产品型号： %9

set TMPPATH=E:\DVB\DATA\Tmp_Data
rem 提取开发负责人姓名，以通知邮件
rem set beizhu=%4
rem for /f "tokens=1,2,3 delims=:" %%a in ("%beizhu%") do (
rem echo %%c
rem set kaifa=%%c
rem )

:: 判断各参数是否为空
set testpara=0
if %1 == "" (
echo 测试包名称为空！
set testpara=1
)
if %2 == "" (
echo 测试包VSS库名为空！
set testpara=1
)
if %3 == "" (
echo 测试包路径为空！
set testpara=1
)
if %4 == "" (
echo 备注信息为空！
set testpara=1
)
if %5 == "" (
echo BL软件包名称为空！
set testpara=1
)
if %6 == "" (
echo BL软件包路径为空！
set testpara=1
)
if %7 == "" (
echo 源代码标签为空！
set testpara=1
)
if %8 == "" (
echo 源代码路径为空！
set testpara=1
)
if %testpara% == 1 (
echo 请修改以上为空的参数,并重新提交!
goto out_err
)

if %5 == tmp goto out_bl
e:
cd E:\DVB\bat\bootloader
call bootloader_post_Compile.bat %TMPPATH%\%1 %5 %6
if %BLRESULT% == error goto out_err
:out_bl

e:
cd "%TMPPATH%\%1"
REM 压缩文件
WinRAR a -r -afzip %1.zip

echo 测试包数据相关源码说明: >luntbuild.txt
echo 1.测试包路径： %3 >>luntbuild.txt
echo 2.备注信息： %4 >>luntbuild.txt
echo 3.BL软件包名称： %5 >>luntbuild.txt
echo 4.BL软件包路径： %6 >>luntbuild.txt
echo 5.源代码标签： %7 >>luntbuild.txt
echo 6.源代码路径： %8 >>luntbuild.txt
echo 7.公司产品型号： %9 >>luntbuild.txt
winrar c -zluntbuild.txt %1.zip

set database=%2
set datapath=%3

echo %3|findstr "svn: http:" 
if %errorlevel%==0 (
echo 源代码配置库为SVN！
set codetype=svn
) else (
echo 源代码配置库为VSS！
set codetype=vss
)

if "%codetype%" == "vss" goto vss

echo 将测试包上传到SVN,路径为：%3
svn import -m %4 "%1.zip" "%3/%1.zip"
if errorlevel 1 goto out_err
goto out


:vss
echo 源代码配置库为：VSS
echo 测试包VSS库名：%database%
echo 测试包VSS路径：%datapath%

echo 将测试包提交到VSS
set ssdir=%database%
ss cp $/%datapath% -I- -Yluntbuild,luntbuild25
echo 删除同名测试包，如已成功提交同名的测试包两次，第三次再提交同名的测试会删除失败！
ss delete %1.zip -I- -Yluntbuild,luntbuild25
ss add %1.zip -I- -Yluntbuild,luntbuild25 -c%4
if errorlevel 1 goto out_err

:out
echo 测试包已上传成功！
echo ****************************测试文件打包并上传测试路径结束*************************
rem 发通知邮件
e:
cd E:\DVB\bat\compile_bat
call complie_email_succeed.vbs gongcheng_%9 %1 %3 %5 %6 %7 %8 %4
exit 0

:out_err
echo 测试包上传失败！
echo ****************************测试文件打包并上传测试路径结束*************************
rem 发通知邮件
e:
cd E:\DVB\bat\compile_bat
call postcomplie_email_error.vbs gongcheng_%9 %1 %3 %5 %6 %7 %8 %4
exit 1



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