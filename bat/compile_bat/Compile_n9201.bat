@echo off
@echo 		******************************************************
@echo 		                Compiling Bat
@echo 		******************************************************

REM set initial variable
REM %1---product
REM %2---new file name
REM %3---code type
REM %4---code label
REM %5---code path

REM *********************SETTING PARAMETERS*******************
set TMPPATH=E:\DVB\DATA\Tmp_Data
set BATPATH=y:
set PRODUCT=%1
set FILENAME=%2
set SRCTYPE=%3
set SRCLABEL=%4
set SRCPATH=%5



echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
y:
echo ���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\hmc2�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\N9201uspmake.sh"

cd %BATPATH%\%PRODUCT%
if not exist filelist.txt (
echo there is no filelist
goto out_err
)

xcopy "%BATPATH%\%PRODUCT%\release2test" /Y/e "%TMPPATH%\%FILENAME%\"
call E:\DVB\bat\filescheck\filescheck.bat %BATPATH%\%PRODUCT% %TMPPATH%\%FILENAME%
REM ����filescheck.batʱ�Ĳ�����filetxt�ĵ�ַ  ����·��
goto end


:end
if %fc_result% == 1 goto out_err
REM Compile completed
exit

:out_err
k:



