echo off

rem Subversion的安装目录及执行文件
set SVN_HOME="C:\Program Files\Subversion\bin"
set SVN_ADMIN=%SVN_HOME%\svnadmin.exe
set SVN_LOOK=%SVN_HOME%\svnlook.exe

rem 配置库仓库根目录
set SVN_REPOROOT=D:\svn

rem 压缩命令
set RAR_CMD="C:\Program Files\WinRAR"

rem 增量备份文件存放路径
set RAR_STORE="D:\svn_increment_backup"

rem 日志及最后一次备份修订号存放文件目录，以下是跟增量备份脚本目录同一目录
set Log_PATH=D:\svn_back_scripts\increment

rem 读取项目库列表文件，并忽略其中;开头的行
FOR /f "eol=;" %%C IN (projectlist.conf) DO call D:\svn_back_scripts\increment\dump.bat %%C