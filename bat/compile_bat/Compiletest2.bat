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

REM ******************CDVB***************************************
:CDVB

if %PRODUCT% == CDVBC5600I (
echo ��ʱ��������ƷCDVB5600I�Զ����������⣬���ֶ�����
goto out_err
)

if %SRCTYPE%==SVN (
cd %BATPATH%
cd ..
rmdir src /S/Q
echo ��SVN�л�ȡ���룺
svn export %SRCLABEL% src
)

cd %BATPATH%
attrib -r /s
REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\test\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\test
)
if %m% ==1 (
echo ָ��·����test����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*
echo ���ڿ�ʼ���룡
call Autobuild.bat
echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\test" "%TMPPATH%\%FILENAME%\" /s/e/y
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\test��
goto out_err
)
goto end

REM ********************UPI****************************************
:UPI
cd %BATPATH%
for /f "tokens=2 delims=\" %%a in ("%BATPATH%") do (
set SUBPATH=%%a
)

cd ..
rmdir %SUBPATH% /S/Q
svn co %SRCLABEL% %SUBPATH%
cd %SUBPATH%
cd %SRCPATH%

set buildpath=%cd%
if not "%SRCPATH%"=="/" ( 
if "%buildpath%"=="%BATPATH%" goto out_err
)

REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%buildpath%
)
if exist "%BATPATH%\output\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\output
)
if %m% ==1 (
echo ָ��·����output����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

call build.bat
echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\output" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\output��
goto out_err
)
goto end

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

echo ���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\hmc2�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.98.188 -pw coship -m "E:\DVB\bat\compile_bat\hmc\make.sh"
echo ��linux�б�����ɣ����˳�linuxϵͳ��
k:
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

REM ********************BCM****************************************
:BCM

cd %BATPATH%\src
REM *���filelist.txt�Ƿ���ڣ�*
set m=1
if exist filelist.txt (
set m=0
set CHECKPATH=%cd%
)
if exist "%BATPATH%\src\release\filelist.txt" (
set m=0
set CHECKPATH=%BATPATH%\src\release
)
if %m% ==1 (
echo ָ��·����release����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

echo pro=%PRODUCT% > y:\colable

echo ���ڽ���linux�б��룬���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\test.sh" 
echo ��linux�б�����ɣ����˳�linuxϵͳ��
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
y:
cd %BATPATH%\src\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\src\release" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\src\release��
goto out_err
)
goto end

REM ************************LINUX***********************************
:LINUX
echo taglable=%SRCLABEL% > %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo pro=%PRODUCT% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err
echo path=%SRCPATH% >>  %BATPATH%\colable
if %errorlevel% == 1 goto out_err



echo ���ڽ���linux�б��룬����鿴������Ϣ���½\\10.10.5.80\luntbuild\LINUX�¶�Ӧ���̲鿴������CMO��ȡ��
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\linux\linux_make.sh"
echo ��linux�б�����ɣ����˳�linuxϵͳ��


cd "%BATPATH%\%PRODUCT%\release2test"
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
echo ָ��·����release2test����δ�ṩfilelist������º����ύ�Զ����룡
goto out_err
)
REM *�����ϣ�*

echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%PRODUCT%\release2test" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\release2test��
goto out_err
)
goto end

REM ********************svn_bcm****************************************
:svn_bcm

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

Y:
cd %BATPATH%\%PRODUCT%\test_rs232
call mkImage.bat
call putty.exe root@10.10.5.80 -pw coshipCM110 -m "E:\DVB\bat\compile_bat\bcm\chmoddir.sh" 
echo ������ɣ����Ʋ����ļ�����ʱ���·��
xcopy "%BATPATH%\%PRODUCT%\release" /y/e "%TMPPATH%\%FILENAME%\"
if errorlevel 1 (
echo ����ʧ�ܣ�������Ŀ¼��%BATPATH%\%PRODUCT%\release��
goto out_err
)
goto end


REM *************
:end
call E:\DVB\bat\filescheck\filescheck.bat %CHECKPATH% %TMPPATH%\%FILENAME%
REM ����filescheck.batʱ�Ĳ�����filetxt�ĵ�ַ  ����·��
if %fc_result% == 1 goto out_err
REM Compile completed
exit 0

:out_err
rem ��֪ͨ�ʼ�
e:
cd E:\DVB\bat\compile_bat
call complie_email_error.vbs %1 %2 %3 %4 %5
exit 1



if [ "$prj1" == "/" ]
then
echo ·��Ϊ"/"�ǷǷ�·��,���޸������ύ> $prjpath/$prj1/makelog 2>&1
exit
fi