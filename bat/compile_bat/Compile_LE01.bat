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



REM ********************HMC****************************************
:HMC
echo taglable=%SRCLABEL% > %BATPATH%\colable
if errorlevel 1 goto out_err
for /f "delims=/ tokens=1*" %%a in ("%SRCPATH%") do (
echo prj1=%%a >>  %BATPATH%\colable
if errorlevel 1 goto out_err
set prj1=%%a
echo prj2=%%b >>  %BATPATH%\colable
if errorlevel 1 goto out_err
set prj2=%%b
)

echo ���ڽ���linux�б��룬����鿴������Ϣ����CMO��ȡ��
call putty.exe root@10.10.5.207 -pw rest -m "E:\DVB\bat\compile_bat\hmc\make.sh"
echo ��linux�б�����ɣ����˳�linuxϵͳ��
Z:
cd %BATPATH%\%prj1%\product\%prj1%\%prj2%

REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test
)
if %m% ==1 (
echo ָ��·����release2test����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%prj1%\product\%prj1%\%prj2%\release2test��
goto out_err
)
goto end

REM ************************LINUX***********************************
:LINUX
echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo ROAD=%SRCPATH% >>  %BATPATH%\colable
set  ROAD=%SRCPATH%
if %errorlevel% == 1 goto out_err



echo ���ڽ���linux�б��룬���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.5.251 -pw coshipCM168 -m "E:\DVB\bat\compile_bat\linux\linux_make_iptv.sh"

echo ��linux�б�����ɣ����˳�linuxϵͳ��

for /f "delims=/ tokens=1,2" %%a in ("%ROAD%") do (
set path1=%%a
set path2=%%b
)
cd "%BATPATH%\%PRODUCT%\%path1%\%path2%\"
REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if %m% ==1 (
echo ָ��·����release2test����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

echo ������ɣ����Ʋ����ļ�����ʱ���·��
cd "%CHECKPATH%\release2test"
xcopy "%CHECKPATH%\release2test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\release2test��
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



