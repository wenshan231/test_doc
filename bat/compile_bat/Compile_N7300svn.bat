@echo off
@echo 		******************************************************
@echo 		                Compiling Bat
@echo 		******************************************************

REM set initial variable
REM %1---product
REM %2---new file name
REM %3---code type
REM %4---code label
REM %5---code path

REM *********************SETTING PARAMETERS*******************
set TMPPATH=E:\DVB\DATA\Tmp_Data
set BATPATH=y:
set PRODUCT=%1
set FILENAME=%2
set SRCTYPE=%3
set SRCLABEL=%4
set SRCPATH=%5



echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
y:
echo 现在进入linux中编译，如需查看编译信息请登陆\\10.10.5.80\luntbuild\hmc2下对应工程查看或者向CMO获取！
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\N7300svnmake.sh"
echo 在linux中编译完成，已退出linux系统！ 

y:
cd %BATPATH%\%PRODUCT%\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
echo 编译完成，复制测试文件到临时打包路径
y:
xcopy "%BATPATH%\%PRODUCT%\release" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo 编译失败，不存在目录：%BATPATH%\%PRODUCT%\release！
goto out_err
)
goto end

cd %BATPATH%\%PRODUCT%
if not exist filelist.txt (
echo there is no filelist
goto out_err
)

xcopy "%BATPATH%\%PRODUCT%\release" /Y/e "%TMPPATH%\%FILENAME%\"
call E:\DVB\bat\filescheck\filescheck.bat %BATPATH%\%PRODUCT% %TMPPATH%\%FILENAME%
REM 调用filescheck.bat时的参数：filetxt的地址  需检查路径
goto end


:end
if %fc_result% == 1 goto out_err
REM Compile completed
exit

:out_err
k:



