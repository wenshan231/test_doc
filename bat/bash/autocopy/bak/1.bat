if not exist D:\bash\autocopy\tmp ( echo [error] %%a not exit pls check && exit 1)

cd  D:\bash\autocopy\tmp
svn export svn://10.10.5.66/SCV500/00.doc/SCV500R002/开发库/01.配置项/1.4_用户资料  用户资料
svn import D:\bash\autocopy\tmp   svn://10.10.5.66/ProcessSystem_Doc/test/doc  -m "svn://10.10.5.66/SCV500/00.doc/SCV500R002/开发库/01.配置项/1.4_用户资料"
if not exist D:\bash\autocopy\tmp\用户资料 ( echo [error] %%a not exit pls check && exit 1)
rd  D:\bash\autocopy\tmp\用户资料  /q /s
pause