echo off

rem Subversion�İ�װĿ¼��ִ���ļ�
set SVN_HOME="C:\Program Files\Subversion\bin"
set SVN_ADMIN=%SVN_HOME%\svnadmin.exe
set SVN_LOOK=%SVN_HOME%\svnlook.exe

rem ���ÿ�ֿ��Ŀ¼
set SVN_REPOROOT=D:\svn

rem ѹ������
set RAR_CMD="C:\Program Files\WinRAR"

rem ���������ļ����·��
set RAR_STORE="D:\svn_increment_backup"

rem ��־�����һ�α����޶��Ŵ���ļ�Ŀ¼�������Ǹ��������ݽű�Ŀ¼ͬһĿ¼
set Log_PATH=D:\svn_back_scripts\increment

rem ��ȡ��Ŀ���б��ļ�������������;��ͷ����
FOR /f "eol=;" %%C IN (projectlist.conf) DO call D:\svn_back_scripts\increment\dump.bat %%C