@echo off
echo ******************************************************************************
echo *                  ����ɹ����������ļ�������ϴ�������·��                  *    
echo ******************************************************************************
echo ��������Ϣ:
echo 1.���԰����ƣ� %1
echo 2.���԰�VSS������ %2
echo 3.���԰�·���� %3
echo 4.��ע��Ϣ�� %4
echo 5.BL��������ƣ� %5
echo 6.BL�����·���� %6
echo 7.Դ�����ǩ�� %7
echo 8.Դ����·���� %8
echo 9.��˾��Ʒ�ͺţ� %9

set TMPPATH=E:\DVB\DATA\Tmp_Data
rem ��ȡ������������������֪ͨ�ʼ�
rem set beizhu=%4
rem for /f "tokens=1,2,3 delims=:" %%a in ("%beizhu%") do (
rem echo %%c
rem set kaifa=%%c
rem )

:: �жϸ������Ƿ�Ϊ��
set testpara=0
if %1 == "" (
echo ���԰�����Ϊ�գ�
set testpara=1
)
if %2 == "" (
echo ���԰�VSS����Ϊ�գ�
set testpara=1
)
if %3 == "" (
echo ���԰�·��Ϊ�գ�
set testpara=1
)
if %4 == "" (
echo ��ע��ϢΪ�գ�
set testpara=1
)
if %5 == "" (
echo BL���������Ϊ�գ�
set testpara=1
)
if %6 == "" (
echo BL�����·��Ϊ�գ�
set testpara=1
)
if %7 == "" (
echo Դ�����ǩΪ�գ�
set testpara=1
)
if %8 == "" (
echo Դ����·��Ϊ�գ�
set testpara=1
)
if %testpara% == 1 (
echo ���޸�����Ϊ�յĲ���,�������ύ!
goto out_err
)

if %5 == tmp goto out_bl
e:
cd E:\DVB\bat\bootloader
call bootloader_post_Compile.bat %TMPPATH%\%1 %5 %6
if %BLRESULT% == error goto out_err
:out_bl

e:
cd "%TMPPATH%\%1"
REM ѹ���ļ�
WinRAR a -r -afzip %1.zip

echo ���԰��������Դ��˵��: >luntbuild.txt
echo 1.���԰�·���� %3 >>luntbuild.txt
echo 2.��ע��Ϣ�� %4 >>luntbuild.txt
echo 3.BL��������ƣ� %5 >>luntbuild.txt
echo 4.BL�����·���� %6 >>luntbuild.txt
echo 5.Դ�����ǩ�� %7 >>luntbuild.txt
echo 6.Դ����·���� %8 >>luntbuild.txt
echo 7.��˾��Ʒ�ͺţ� %9 >>luntbuild.txt
winrar c -zluntbuild.txt %1.zip

set database=%2
set datapath=%3

echo %3|findstr "svn: http:" 
if %errorlevel%==0 (
echo Դ�������ÿ�ΪSVN��
set codetype=svn
) else (
echo Դ�������ÿ�ΪVSS��
set codetype=vss
)

if "%codetype%" == "vss" goto vss

echo �����԰��ϴ���SVN,·��Ϊ��%3
svn import -m %4 "%1.zip" "%3/%1.zip"
if errorlevel 1 goto out_err
goto out


:vss
echo Դ�������ÿ�Ϊ��VSS
echo ���԰�VSS������%database%
echo ���԰�VSS·����%datapath%

echo �����԰��ύ��VSS
set ssdir=%database%
ss cp $/%datapath% -I- -Yluntbuild,luntbuild25
echo ɾ��ͬ�����԰������ѳɹ��ύͬ���Ĳ��԰����Σ����������ύͬ���Ĳ��Ի�ɾ��ʧ�ܣ�
ss delete %1.zip -I- -Yluntbuild,luntbuild25
ss add %1.zip -I- -Yluntbuild,luntbuild25 -c%4
if errorlevel 1 goto out_err

:out
echo ���԰����ϴ��ɹ���
echo ****************************�����ļ�������ϴ�����·������*************************
rem ��֪ͨ�ʼ�
e:
cd E:\DVB\bat\compile_bat
call complie_email_succeed.vbs gongcheng_%9 %1 %3 %5 %6 %7 %8 %4
exit 0

:out_err
echo ���԰��ϴ�ʧ�ܣ�
echo ****************************�����ļ�������ϴ�����·������*************************
rem ��֪ͨ�ʼ�
e:
cd E:\DVB\bat\compile_bat
call postcomplie_email_error.vbs gongcheng_%9 %1 %3 %5 %6 %7 %8 %4
exit 1



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