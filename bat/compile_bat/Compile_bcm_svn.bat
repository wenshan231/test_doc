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
Y:
call putty.exe root@10.10.5.80 -pw coshipCM -m "E:\DVB\bat\compile_bat\bcm\bcmsvn\make.sh"

call putty.exe root@10.10.5.80 -pw coshipCM -m "E:\DVB\bat\compile_bat\bcm\bcmsvn\chmoddir.sh" 
echo ��linux�б�����ɣ����˳�linuxϵͳ��
Y:
cd %BATPATH%\%PRODUCT%\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw Coshipcm -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh"  
echo ���Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%PRODUCT%\release" /Y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\release��
goto out_err
)
goto end


:end
REM Compile completed
exit

:out_err
k:



