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
set BATPATH=Y:
set PRODUCT=%1
set FILENAME=%2
set SRCTYPE=%3
set SRCLABEL=%4
set SRCPATH=%5



echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo srcpath=%SRCPATH% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo ���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\�¶�Ӧ���̲鿴������CMO��ȡ��
Y:
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\linux\makegj.sh"

call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\bcmsvn\chmoddir.sh" 
echo ��linux�б�����ɣ����˳�linuxϵͳ��

echo ���Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%PRODUCT%\output" /Y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\output��
goto out_err
)
goto end


:end
REM Compile completed
exit

:out_err
k:



