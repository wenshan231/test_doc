@REM parameter
@echo 		******************************************************
@echo 		          autocopy all package from auto make path or svn path
@echo 		         Written by qiaoting on 2013.05.08
@echo 		******************************************************
@REM parameter
@REM %1
@REM %2

D:
set ip1_address=10.10.5.165
set ip2_address=10.10.5.166
set svn_path=http://10.10.5.52
rem mkdir test\%product_version%
rem svn import  test\%product_version% %svn_dir_path%  -m "%product_version% test" 
rem if errorlevel 1 goto err_version
svn list %svn_dir_path%/%product_version%
if ERRORLEVEL 1 goto err_version


set mdl_all=%mdl1_path% %mdl2_path% %mdl3_path%
echo %mdl_all%
for %%i in (%mdl_all%) do  (
	echo %%i
	echo %%i | findstr "%ip1_address% %ip2_address% %svn_path%" 
	if ERRORLEVEL 1 goto err
 )


for %%a in (%mdl_all%) do  (
	echo %%a
	echo %%a | findstr %svn_path%
	if ERRORLEVEL  0 (
	svn copy  %%a %svn_dir_path%/%product_version% -m "already tested,from %%a copy" --username qiaoting --password 789123  &&  echo "svn copy %%a ok" || echo "svn copy %%a error"
	)
	
	svn import %%a %svn_dir_path%/%product_version%  -m "%%a test" --username qiaoting --password 789123 &&  echo "svn ci %%a ok" || echo "svn ci %%a error"
)
pause

:err_version
echo %svn_dir_path%/%product_version% 已经存在,请核对版本号
exit 1


:err
echo 软件包必须从自动构建中获取(5.166)或从测试库中已经存在(与上次比较没有改的模块)
pause
exit 1

