@ECHO OFF
rem 调用格式：dump 项目库名
if "%1"=="" goto no_args
set PROJECT=%1
if not exist %RAR_STORE%\%PROJECT% mkdir %RAR_STORE%\%PROJECT%
cd %RAR_STORE%\%PROJECT%
SET LOWER=0
SET UPPER=0

if not exist %Log_PATH%\%PROJECT% mkdir %Log_PATH%\%PROJECT%
@echo 项目库%PROJECT%开始备份>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
%SVN_LOOK% youngest %SVN_REPOROOT%\%PROJECT%> %Log_PATH%\A.TMP
@FOR /f %%D IN (%Log_PATH%\A.TMP) DO set UPPER=%%D
if %UPPER%==0 GOTO :N_EXIT
if not exist %Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt GOTO :BAKUP

rem 取出上次备份后的版本号，并做＋1处理(注意此算法未在98系统验证)
@FOR /f %%C IN (%Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt) DO @set LOWER=%%C
@set /A LOWER=%LOWER%+1

rem 不需要备份，则跳转结束
IF %LOWER% gtr %UPPER% GOTO :N_EXIT

:BAKUP
SET FILENAME=%PROJECT%_%LOWER%_%UPPER%
@ECHO 开始备份项目库：%PROJECT%，生成文件=%FILENAME%
%SVN_ADMIN% dump %SVN_REPOROOT%\%PROJECT% -r %LOWER%:head --incremental >%FILENAME%.dmp

rem %RAR_CMD% a -df %PROJECT%_%UPPER%.rar %
rem 准备写备份日志信息
IF %LOWER% gtr 0 GOTO :WRITENOTE
@ECHO %PROJECT%备份时间: %date% >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@echo %PROJECT%备份revision区间 从[%LOWER%]到[%UPPER%] >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
GOTO :COMPLETE

:WRITENOTE
@ECHO %date% >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@echo -- 4------添加增量备份文件 %PROJECT%_%UPPER%.rar，从[%LOWER%]到[%UPPER%] >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt

:COMPLETE
rem 下面一行用于拷贝备份文件到目标地址
@echo 将dump备份文件%FILENAME%.dmp 转移至%RAR_STORE%\%PROJECT% 目录下 >> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
move %FILENAME%.dmp %RAR_STORE%\%PROJECT%\
del %Log_PATH%\A.TMP
@echo %UPPER% > %Log_PATH%\%PROJECT%\%PROJECT%_last_revision.txt

:N_EXIT
@echo 项目库%PROJECT%处理结束！>> %Log_PATH%\%PROJECT%\%PROJECT%_log.txt
@CD..
@exit /B
:no_args
@ECHO ON
@echo "请正确使用svnadmin dump命令： dump 项目库名"