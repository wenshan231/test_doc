if not exist D:\bash\autocopy\tmp ( echo [error] %%a not exit pls check && exit 1)

cd  D:\bash\autocopy\tmp
svn export svn://10.10.5.66/SCV500/00.doc/SCV500R002/������/01.������/1.4_�û�����  �û�����
svn import D:\bash\autocopy\tmp   svn://10.10.5.66/ProcessSystem_Doc/test/doc  -m "svn://10.10.5.66/SCV500/00.doc/SCV500R002/������/01.������/1.4_�û�����"
if not exist D:\bash\autocopy\tmp\�û����� ( echo [error] %%a not exit pls check && exit 1)
rd  D:\bash\autocopy\tmp\�û�����  /q /s
pause