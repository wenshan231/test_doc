echo off
echo 		******************************************************
echo 		          autocopy all package from auto make path or svn path
echo 		         Written by qiaoting on 2013.05.08
echo 		******************************************************
rem parameter
rem 
rem 
set svn_dir_path=http://10.10.5.52/Test/SCV500/SCV500R001/SCV500R001B02
set product_version=SCV500R001B02h

set mdl1_path=\\10.10.5.165\share\166output\SCV_CMS_trunk\builds\2013-05-08_10-21-34\archive\src\output
set mdl2_path=\\10.10.5.165\share\166output\AppStore_client123\builds\2013-05-06_15-06-05\archive\CIBN_out\output
set mdl3_path=http://10.10.5.52/Test/SCV500/SCV500R001/SCV500R001B02/SCV500R001B022/CIBN_MovieonLine_svn.1201_20130507174749.zip


D:
set ip1_address=10.10.5.165
REM set ip2_address=10.10.5.166
set svn_path=10.10.5.52
rem mkdir test\%product_version%
rem svn import  test\%product_version% %svn_dir_path%  -m "%product_version% test" 
rem if errorlevel 1 goto err_version
svn list %svn_dir_path%/%product_version%
if %errorlevel% EQU 0 goto err_version


set mdl_all=%mdl1_path% %mdl2_path% %mdl3_path%
echo %mdl_all%
setlocal enabledelayedexpansion
for %%a in (%mdl_all%) do (
	echo %%a
	echo !ERRORLEVEL!
	echo "%%a" | findstr /m/i "10.10.5.165 10.10.5.52"
	IF !ERRORLEVEL!==1 	goto err
	
	echo "%%a" | findstr /m/i "10.10.5.165"
	IF !ERRORLEVEL!==0 (
	echo "%%a"
	echo hello
	if not exist %%a goto file_path_error
	 ) else (
	svn list %%a
	IF !ERRORLEVEL!==1 goto svn_path_error)
		  
)
pause


rem svn checkin

for %%b in (%mdl_all%) do  (
	echo %%b
	echo %%b | findstr %svn_path%
	if !ERRORLEVEL!==0 ( svn copy  %%b %svn_dir_path%/%product_version% -m "%%b test"  &&  echo "svn copy %%b ok" || goto svn_ci_error )	else (svn import %%b %svn_dir_path%/%product_version%  -m "%%b test" &&  echo "svn ci %%b ok" || goto svn_ci_error)
)

REM copy finished
exit 0

:err_version
echo exit %svn_dir_path%/%product_version% ,pls check product version
exit 1


:svn_ci_error
echo svn_ci error,pls check automake path or svn path
pause
exit 1

:file_path_error
echo file_path error,pls check automake path
pause
exit 1

:svn_path_error
echo svn_path error,pls check automake path
pause
exit 1




:err
echo package must from 5.166 or http://10.10.5.52(if exit package)
pause
exit 1

