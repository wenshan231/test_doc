echo off
rem ��ͬһ��Ŀ¼�µĶ���汾��ȫ������
rem Subversion�İ�װĿ¼
set SVN_HOME="C:\Program Files\VisualSVN Server"

rem ���а汾��ĸ�Ŀ¼
set SVN_ROOT="D:\Repositories"

rem ���ݵ�Ŀ¼
set BACKUP_SVN_ROOT=Y:\Repositories

set BACKUP_DIRECTORY=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
if exist %BACKUP_DIRECTORY% goto checkBack
echo ��������Ŀ¼%BACKUP_DIRECTORY%

cd /d %BACKUP_SVN_ROOT%
mkdir %BACKUP_DIRECTORY%

for /f "delims=" %%a in ('dir /a:d /b D:\Repositories') do (
set REPOS_NAME=%%a
call:backup
)
goto end


:backup
echo ���ڱ��ݰ汾��%REPOS_NAME%......
svnadmin hotcopy  D:\Repositories\%REPOS_NAME% %BACKUP_DIRECTORY%\%REPOS_NAME%"
goto end


:checkBack
echo ����Ŀ¼%BACKUP_DIRECTORY%�Ѿ����ڣ������.
goto end


:end

