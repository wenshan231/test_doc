echo off

rem Subversion�İ�װĿ¼
set SVN_HOME="C:\Program Files\Subversion\bin"

rem ���а汾��ĸ�Ŀ¼
set SVN_ROOT=D:\svn

rem ���ݵ�Ŀ¼
set BACKUP_SVN_ROOT=D:\svn_full_backup
set BACKUP_DIRECTORY=%BACKUP_SVN_ROOT%\%date:~0,10%
if exist %BACKUP_DIRECTORY% goto checkBack
echo ��������Ŀ¼%BACKUP_DIRECTORY%>>%SVN_ROOT%/fullbackup.log
mkdir %BACKUP_DIRECTORY%

rem ��֤Ŀ¼�Ƿ�Ϊ�汾�⣬�������ȡ�����Ʊ���
for /r %SVN_ROOT% %%I in (.) do @if exist "%%I\conf\svnserve.conf" hotcopy.bat "%%~fI" %%~nI

mkdir %BACKUP_DIRECTORY%\conf
xcopy %SVN_ROOT%\conf %BACKUP_DIRECTORY%\conf
goto end

:checkBack
echo ����Ŀ¼%BACKUP_DIRECTORY%�Ѿ����ڣ�����ա�
goto end
:end