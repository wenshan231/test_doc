@echo off
echo *************************************************************************
echo *                          ���벢�������ļ�                           *
echo *************************************************************************

echo ��������Ϣ��
echo 1.��Ʒ�ͺţ�  %1
echo 2.���԰��ļ����ƣ�  %2
echo 3.Դ�������ͣ�  %3
echo 4.Դ�����ǩ��  %4
echo 5.Դ����·����  %5

:: ���ñ���
set TMPPATH=E:\DVB\DATA\Tmp_Data
set PRODUCT=%1
set FILENAME=%2
set SRCTYPE=%3
set SRCLABEL=%4
set SRCPATH=%5

E:
for /f "eol=# tokens=1,2,3 delims= " %%a in (E:\DVB\bat\compile_bat\product_type.txt) do (
if %%a==%PRODUCT% (
set TYPE=%%b
set BATPATH=%%c
)
)
echo ��������Ϊ��%TYPE%
echo ����·��Ϊ��%BATPATH%

for /f "delims=\,tokens=1" %%a in ("%BATPATH%") do set dr=%%a
%dr%
cd %BATPATH%

REM Start Compiling
goto %TYPE%

REM ************************N9202***********************************
:N9202
echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo path=%SRCPATH% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err



echo ���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\LINUX�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\linux\linux_make1.sh"
echo ��linux�б�����ɣ����˳�linuxϵͳ��


cd "%BATPATH%\%PRODUCT%\%SRCPATH%\release2test"
REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\%PRODUCT%\%SRCPATH%\filelist.txt" (
set m=0
set CHECKPATH="%BATPATH%\%PRODUCT%\%SRCPATH%"
)
if exist "%BATPATH%\%PRODUCT%\filelist.txt" (
set m=0
set CHECKPATH="%BATPATH%\%PRODUCT%"
)
if %m% ==1 (
echo ָ��·����Release2Test����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%PRODUCT%\%SRCPATH%\Release2Test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\%SRCPATH%\Release2Test��
goto out_err
)
goto end


:end
call E:\DVB\bat\filescheck\filescheck.bat %CHECKPATH% %TMPPATH%\%FILENAME%
REM ����filescheck.batʱ�Ĳ�����filetxt�ĵ�ַ  ����·��
if %fc_result% == 1 goto out_err
REM Compile completed
exit 0

:out_err
exit 1



