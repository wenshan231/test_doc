
echo ###################### copy �û����� ###########################

if not exist D:\bash\autocopy\tmp ( echo [error] D:\bash\autocopy\tmp not exit pls check && exit 1)
if  exist D:\bash\autocopy\tmp\SCV500  rd  D:\bash\autocopy\tmp\SCV500  /q /s

cd  D:\bash\autocopy\tmp
svn export %mdl0_path%  SCV500
svn import D:\bash\autocopy\tmp\SCV500    "%svn_dir_path%/%product_version%/doc/��װ�ĵ�"  -m "%mdl0_path%"
if "%errorlevel%" == "1"   goto svn_path_error


echo ###################### copy �û����Ͻ��� ###########################

