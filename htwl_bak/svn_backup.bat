echo off
rem 将同一个目录下的多个版本库全量备份
rem Subversion的安装目录
set SVN_HOME="C:\Program Files\VisualSVN Server"

rem 所有版本库的父目录
set SVN_ROOT="D:\Repositories"

rem 备份的目录
set BACKUP_SVN_ROOT=Y:\Repositories

set BACKUP_DIRECTORY=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
if exist %BACKUP_DIRECTORY% goto checkBack
echo 建立备份目录%BACKUP_DIRECTORY%

cd /d %BACKUP_SVN_ROOT%
mkdir %BACKUP_DIRECTORY%

for /f "delims=" %%a in ('dir /a:d /b D:\Repositories') do (
set REPOS_NAME=%%a
call:backup
)
goto end


:backup
echo 正在备份版本库%REPOS_NAME%......
svnadmin hotcopy  D:\Repositories\%REPOS_NAME% %BACKUP_DIRECTORY%\%REPOS_NAME%"
goto end


:checkBack
echo 备份目录%BACKUP_DIRECTORY%已经存在，请清空.
goto end


:end

