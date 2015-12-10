@REM parameter
@echo 		******************************************************
@echo 		          autocopy all package from auto make path or svn path
@echo 		         Written by qiaoting on 2013.05.08
@echo 		******************************************************
@REM parameter
@REM %1
@REM %2

set svn_dir_path=http://10.10.5.52/Test/SCV500/SCV500R001/SCV500R001B02
set product_version=SCV500R001B020

set mdl1_path=\\10.10.5.165\share\166output\SCV_CMS_trunk\builds\2013-05-08_10-21-34\archive\src\output
set mdl2_path=\\10.10.5.165\share\166output\APP_com.coship.adjustthevolume\lastSuccessful\archive\output
set mdl3_path=http://10.10.5.52/Test/SCV500/SCV500R001/SCV500R001B02/SCV500R001B022/CIBN_MovieonLine_svn.1201_20130507174749.zip


D:
set ip1_address=10.10.5.165
REM set ip2_address=10.10.5.166
set svn_path=http://10.10.5.52
rem mkdir test\%product_version%
rem svn import  test\%product_version% %svn_dir_path%  -m "%product_version% test" 
rem if errorlevel 1 goto err_version
svn list %svn_dir_path%/%product_version%
if %errorlevel% EQU 0 goto err_version


set mdl_all=%mdl1_path% %mdl2_path% %mdl3_path%
echo %mdl_all%
for %%i in (%mdl_all%) do  (
	echo %%i | findstr "%ip1_address% || %svn_path%" 
	if %errorlevel% EQU 1 (echo error goto err )
	rem svn list %%i 
	rem echo %i%
	rem if %errorlevel% EQU 1 (
	rem if not exit %%i goto err_version
  rem	)
	
 )
pause

REM for %%a in (%mdl_all%) do  (
REM 	echo %%a
REM 	echo %%a | findstr %svn_path%
REM 	if ERRORLEVEL  0 (
REM svn copy  %%a %svn_dir_path%/%product_version% -m "already tested,from %%a copy"  &&  echo "svn copy %%a ok" || echo "svn copy %%a error"
REM	)
	
	svn import %%a %svn_dir_path%/%product_version%  -m "%%a test" &&  echo "svn ci %%a ok" || echo "svn ci %%a error"
)
pause

:err_version
echo exit %svn_dir_path%/%product_version% ,pls check product version
exit 1

:err_path
echo not exit %%1 ,pls check autocompile path
exit 1



:err
echo package must from 5.166 or http://10.10.5.52(if exit package)
pause
exit 1

