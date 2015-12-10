echo off
echo 		******************************************************
echo 		          autocopy all package from auto make path or svn path
echo 		         Written by qiaoting on 2013.05.08
echo 		******************************************************
rem parameter
rem 
rem 
set svn_dir_path=svn://10.10.5.66/B2C_TestRelease/Test/SCV500
set product_version=SCV500R001B02i

set mdl1_path=svn://10.10.5.66/B2C_TestRelease/Test/SCV500/SCV500R001B02/SCV500R001B023/ADIAdapter_V500R001B01_svn.2774_20130513154813.zip
set mdl2_path=\\10.10.5.161\share_windows\SCV500_IEPGM\builds\2013-08-08_18-06-00\archive\output
set mdl3_path=svn://10.10.5.66/B2C_TestRelease/doc/SCV500/SCV500R001B02/SCV500R001B026/doc


D:
set ip1_address=10.10.5.161
REM set ip2_address=10.10.5.166
set svn_path=10.10.5.66
rem mkdir test\%product_version%
rem svn import  test\%product_version% %svn_dir_path%  -m "%product_version% test" 
rem if errorlevel 1 goto err_version
svn list %svn_dir_path%/%product_version%
if %errorlevel% EQU 0 goto err_version
svn  mkdir %svn_dir_path%/%product_version% -m "%product_version%"


set mdl_all=%mdl1_path% %mdl2_path% %mdl3_path%
echo %mdl_all%
echo %mdl_all%
echo %mdl_all%
echo %mdl_all%
setlocal enabledelayedexpansion
for %%a in (%mdl_all%) do (
	echo %%a
	echo !ERRORLEVEL!
	echo "%%a" | findstr /m/i "10.10.5.161  10.10.5.165 10.10.5.66"
	IF !ERRORLEVEL!==1 	goto err
	
	echo "%%a" | findstr /m/i "10.10.5.161 10.10.5.165 "
	IF !ERRORLEVEL!==0 (
	echo "%%a"
	echo hello
	if not exist %%a ( echo [error] %%a not exit pls check && exit 1)
	 ) else (
	svn list %%a
	IF !ERRORLEVEL!==1 ( echo [error] %%a not exit pls check && exit 1))
		  
)
pause


rem svn checkin


for %%b in (%mdl_all%) do  (
	echo %%~nxb
	echo %%b
	echo %%b | findstr %svn_path%
	if !ERRORLEVEL!==0 ( svn copy  %%b %svn_dir_path%/%product_version%/%%~nxb -m "%%b test"  --username qiaoting --password 789123 &&  echo "svn copy %%b ok" || goto svn_ci_error )	else (svn import %%b %svn_dir_path%/%product_version%  -m "%%b test" --username qiaoting --password 789123 &&  echo "svn ci %%b ok" || goto svn_ci_error)
)

REM copy finished
exit 0

:err_version
echo [error] exit %svn_dir_path%/%product_version% ,pls check product version
exit 1



:svn_path_error
echo [error] svn_ci error,pls cmo check
pause
exit 1


:err
echo [error] package must from 5.165 or 5.161 or http://10.10.5.66(if exit package)
pause
exit 1

