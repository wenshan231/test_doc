@ECHO OFF
rem ���ø�ʽ��dump ��Ŀ����
if "%1"=="" goto no_args
set PROJECT=%1
if not exist %RAR_STORE%\%PROJECT% mkdir %RAR_STORE%\%PROJECT%
cd %RAR_STORE%\%PROJECT%
SET LOWER=0
SET UPPER=0

if not exist %Log_PATH%\%PROJECT% mkdir %Log_PATH%\%PROJECT%
@echo ��Ŀ��%PROJECT%��ʼ����>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_LOOK% youngest %SVN_REPOROOT%\%PROJECT%> %Log_PATH%\A.TMP
@FOR /f %%D IN (%Log_PATH%\A.TMP) DO set UPPER=%%D
if %UPPER%==0 GOTO :N_EXIT
if not exist %Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt GOTO :BAKUP

rem ȡ���ϴα��ݺ�İ汾�ţ�������1����(ע����㷨δ��98ϵͳ��֤)
@FOR /f %%C IN (%Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt) DO @set LOWER=%%C
@set /A LOWER=%LOWER%+1

rem ����Ҫ���ݣ�����ת����
IF %LOWER% gtr %UPPER% GOTO :N_EXIT

:BAKUP
SET FILENAME=%PROJECT%_%LOWER%_%UPPER%
@ECHO ��ʼ������Ŀ�⣺%PROJECT%�������ļ�=%FILENAME%
%SVN_ADMIN% dump %SVN_REPOROOT%\%PROJECT% -r %LOWER%:head --incremental >%FILENAME%.dmp

rem %RAR_CMD% a -df %PROJECT%_%UPPER%.rar %
rem ׼��д������־��Ϣ
IF %LOWER% gtr 0 GOTO :WRITENOTE
@ECHO %PROJECT%����ʱ��: %date% >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@echo %PROJECT%����revision���� ��[%LOWER%]��[%UPPER%] >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
GOTO :COMPLETE

:WRITENOTE
@ECHO %date% >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@echo -- 4------������������ļ� %PROJECT%_%UPPER%.rar����[%LOWER%]��[%UPPER%] >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt

:COMPLETE
rem ����һ�����ڿ��������ļ���Ŀ���ַ
@echo ��dump�����ļ�%FILENAME%.dmp ת����%RAR_STORE%\%PROJECT% Ŀ¼�� >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
move %FILENAME%.dmp %RAR_STORE%\%PROJECT%\
del %Log_PATH%\A.TMP
@echo %UPPER% > %Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt

:N_EXIT
@echo ��Ŀ��%PROJECT%���������>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@CD..
@exit /B
:no_args
@ECHO ON
@echo "����ȷʹ��svnadmin dump��� dump ��Ŀ����"