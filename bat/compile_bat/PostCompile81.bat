@echo off
echo ******************************************************************************
echo *		           ����ɹ����������ļ�������ϴ�������·��		  *    
echo ******************************************************************************
echo ��������Ϣ:
echo ���԰����ƣ�%1
echo ���԰�VSS������%2
echo ���԰�·����%3
echo ��ע��Ϣ��%4
echo BL��������ƣ�%5
echo BL�����·����%6
echo Դ�����ǩ��%7
echo Դ����·����%8

set TMPPATH=E:\DVB\DATA\Tmp_Data

: �жϸ������Ƿ�Ϊ��

if %1 == "" goto out_err
if %2 == "" goto out_err
if %3 == "" goto out_err
if %4 == "" goto out_err
if %5 == "" goto out_err
if %6 == "" goto out_err
if %7 == "" goto out_err
if %8 == "" goto out_err

if %5 == tmp goto out_bl
e:
cd E:\DVB\bat\bootloader
call bootloader_post_Compile.bat %TMPPATH%\%1 %5 %6
if %BLRESULT% == error (
echo ��ȡBootloader�����ʧ�ܣ�
goto out_err
)
:out_bl

e:
cd "%TMPPATH%\%1"
REM ѹ���ļ�
WinRAR a -r -afzip %1.zip

set codetype=vss
set database=%2
set datapath=%3

for /f "tokens=1* delims=:" %%a in ("%7") do set codetype=%%a
echo codetype��%codetype%

if NOT "%codetype%" == "svn" goto vss

for /f "tokens=1* delims=:" %%i in ("%3") do set tpath=%%i

if "%tpath%" == "http" (
svn import -m %4 "%1.zip" %3/"%1.zip"
if %errorlevel% == 1 goto out_err
goto out
) else (
for /f "tokens=1* delims=/" %%x in ("%3") do (
set dbase=%%x
set database=\\192.168.99.101\%%x
set datapath=%%y
)
)

:vss
echo %database%
echo %datapath%

REM add .zip to VSS
set ssdir=%database%
ss cp $/%datapath% -I- -Yluntbuild,luntbuild25
REM ɾ���ļ����������ͬ���ļ�//���һ�����ύ���β������룬��ÿ�����ƾ���ͬ������������
ss delete %1.zip -I- -Yluntbuild,luntbuild25
ss add %1.zip -I- -Yluntbuild,luntbuild25 -c%4

:out
echo �ύ�ɹ�
exit

:out_err
echo �ύʧ��
K:



rem if %errorlevel% == 0 (
rem for /f "tokens=3 delims=:" %%a in (%4) do set dlname=%%a
rem find "%dlname%"<"E:\DVB\bat\sendmail\������Ӫ������Ա.txt"
rem if %errorlevel% == 0 (
rem call E:\DVB\bat\sendmail\sendmail.vbs %4��ͨ���Զ������ύ���ԣ���֪Ϥ�� �����������%1.zip
rem )
rem ) else (
rem echo add package is failed
rem goto out_err
rem )