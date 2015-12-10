echo 		******************************************************
echo 		          autoinstall package CDN
echo 		    
echo 		******************************************************
rem parameter
rem 
rem 


rem  set mdl1_path=\\10.10.5.161\share_windows\SCV500_CDN_CL_CG\builds\2013-10-29_16-09-33\archive\trunk\integration
rem  set mdl2_path=\\10.10.5.161\share_windows\SCV500_CDN_CI\builds\2013-10-29_16-10-15\archive\trunk\integration
rem  set mdl3_path=svn://10.10.5.66/B2C_TestRelease/Test/SCV500/SCV500R002/SCV500R002B07/RTCL_V300R006B038_svn.1960_20130924185242.zip


D:

set ip1_address=10.10.5.161
set svn_path=10.10.5.66
set WORKSPACE=%WORKSPACE%
rem   set product_version=%2%

cd/d %WORKSPACE%\components
set mdl_all=%mdl1_path% %mdl2_path% %mdl3_path% %mdl4_path% %mdl5_path% %mdl6_path% %mdl7_path% %mdl8_path% %mdl9_path% %mdl10_path% %mdl11_path%  %mdl12_path%  %mdl13_path%  %mdl14_path%  %mdl15_path% %mdl16_path%  %mdl17_path%   %mdl18_path%  %mdl19_path%
echo %mdl_all%
echo %mdl_all%
echo %mdl_all%
echo %mdl_all%
setlocal enabledelayedexpansion
for %%a in (%mdl_all%) do (
	echo %%a
	echo !ERRORLEVEL!
	echo "%%a" | findstr /m/i "10.10.5.161 10.10.96.171 10.10.5.165 10.10.5.66"
	IF !ERRORLEVEL!==1 	goto err
	
	echo "%%a" | findstr /m/i "10.10.5.161 10.10.96.171  10.10.5.165 "
	IF !ERRORLEVEL!==0 (
	echo "%%a"
	echo hello
	if not exist %%a ( echo [error] %%a not exit pls check && exit 1)
	 ) else (
	svn list %%a
	IF !ERRORLEVEL!==1 ( echo [error] %%a not exit pls check && exit 1))
		  
)
pause



for %%b in (%mdl_all%) do  (
	echo %%b | findstr %svn_path%
	if !ERRORLEVEL!==0 ( svn export   %%b &&  echo " copy %%b to components  ok" || goto copy_error )  else  (xcopy    %%b  /Y/e "%WORKSPACE%\components\")
)



@REM *** getout time  date_value***** 

set d=%date:~0,10%
set d=%d:-=%
if %time:~0,2% leq 9 (set h=0%time:~1,1%) else (set h=%time:~0,2%)
set m=%time:~2,6%
set m=%m::=%
set date_value=%d%%h%%m%
echo %date_value% 

@REM *** getout git_version***** 
cd/d %WORKSPACE%
call git rev-parse HEAD >> gitversion.txt
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1" %%i in (%WORKSPACE%\gitversion.txt) do (
set b=%%i
del  gitversion.txt
)

set gitversion=%b:~0,8%




cd/d  %WORKSPACE%

call "C:\Program Files\WinRAR\WinRAR.exe" a -esh  -afzip -r -df %product_version%.git.%gitversion%.%date_value%.zip components  tool


pause
exit 0


:svn_path_error
echo [error] svn_ci error,pls cmo check
pause
exit 1


:err
echo [error] package must from 5.165 or 5.161  or 96.171 or svn://10.10.5.66(if exit package)
pause
exit 1

:copy_error
echo [error] copy_error
pause
exit 1
