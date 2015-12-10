@echo 		******************************************************
@echo 		           CDVB5800 PostCompile Testing Bat  Post
@echo 		      Written by Wangyan on Dec. 28, 2006
@echo                   modify by xuzhihui on Aug 23th,2007
@echo                    modify by youqingli on Sep 30th,2007
@echo                      modify  xuzhihui on Nov 6th,2007
@echo 		******************************************************

@REM set initial variable
@set SRCPATH=E:\DVB\DATA\AnySight108\AutoBuild\src
@set TMPPATH=E:\DVB\DATA\Tmp_Data

@REM parameter
@REM %1---new file name
@REM %2---testdb
@REM %3---testpath
@REM %4---comment(订单编号+提交用户名)


REM Judge whether the parameter is null or not
if %1 == "" goto out_err
if %2 == "" goto out_err
if %3 == "" goto out_err
if %5 == "" goto out_err

REM Judge whether the flash_c.bin has been created or not
E:
REM Create new folder to save flash_c.bin
cd "%TMPPATH%"
REM Delete the folder if it has the same name as %1
if exist %1 rmdir /S/Q %1
mkdir %1

cd "%SRCPATH%"
if exist test (
cd test
if NOT exist flash_c.bin goto out_err
xcopy "%SRCPATH%\test" "%TMPPATH%\%1" /S
goto end
@echo -----------------------------------
@echo it's compile path is the root [NEW]
@echo -----------------------------------

) else if exist ST5105 (
cd "%SRCPATH%\ST5105\src\apps\objs\ST20"
if NOT exist flash_c.bin goto out_err
copy "%SRCPATH%\ST5105\src\apps\objs\ST20\flash_c.bin" /Y "%TMPPATH%\%1"
copy "%SRCPATH%\ST5105\src\apps\objs\ST20\AnySight108_app.rs232" /Y "%TMPPATH%\%1"
cd "%SRCPATH%"
if NOT exist sysconfig_ip.flash goto out_err
if NOT exist sysinfo_ip.flash goto out_err
copy "%SRCPATH%\sysconfig_ip.flash" /Y "%TMPPATH%\%1"
copy "%SRCPATH%\sysinfo_ip.flash" /Y "%TMPPATH%\%1"
@echo -------------------------------------
@echo it's compile path is ST5105 [OLDER]
@echo -------------------------------------
goto end
) else (
cd "%SRCPATH%\src\apps\objs\ST20"
if NOT exist flash_c.bin goto out_err
copy "%SRCPATH%\src\apps\objs\ST20\flash_c.bin" /Y "%TMPPATH%\%1"
copy "%SRCPATH%\src\apps\objs\ST20\AnySight108_app.rs232" /Y "%TMPPATH%\%1"
cd "%SRCPATH%"
if NOT exist sysconfig_ip.flash goto out_err
if NOT exist sysinfo_ip.flash goto out_err
copy "%SRCPATH%\sysconfig_ip.flash" /Y "%TMPPATH%\%1"
copy "%SRCPATH%\sysinfo_ip.flash" /Y "%TMPPATH%\%1"
@echo -------------------------------------
@echo it's compile path is src [OLDER]
@echo -------------------------------------
)

:end

cd "%TMPPATH%\%1"
rename flash_c.bin %1_flash_c.bin
rename AnySight108_app.rs232 %1_AnySight108_app.rs232
rename sysinfo_ip.flash %1_sysinfo_ip.flash
rename sysconfig_ip.flash %1_sysconfig_ip.flash
  


cd E:\DVB\bat
call bootloader_compile.bat %5 %6 %7 %8 %9 %1 

if %BLRESULT% == error goto out_err

cd "%TMPPATH%\%1"
REM Compress files by WINRAR  
WinRAR a -afzip %1.zip

REM add .zip to VSS
set ssdir=%2
ss cp $%3 -Yluntbuild,luntbuild25
REM 删除文件，避免出现同名文件//如果一天内提交三次测试申请，且每次名称均相同，则会出现问题
ss delete %1.zip -I- -Yluntbuild,luntbuild25
ss add %1.zip -I- -Yluntbuild,luntbuild25 -C%4

REM success
exit

:out_err
K: