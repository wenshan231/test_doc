@echo on
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
cd ..
e:

rmdir nmsbuild /S/Q


svn cp -m "view:weijiang ......" "%SRCPATH%" "%SRCLABEL%"
if errorlevel 1 (
echo ���ɱ�ǩʧ��
)

svn export %SRCLABEL% nmsbuild

REM ******COMPILE SERVER********
e:
cd e:\nmsbuild\server
call auto_build.bat


cd e:\nmsbuild\client
call auto_build.bat

REM ****************************************
if not exist "e:\nmsbuild\test-release\software\CoshipNMSServer.tar.gz" (
echo ����ʧ�ܣ�δ����CoshipNMSServer.tar.gzѹ������
goto out_erro
)

if not exist "e:\nmsbuild\test-release\software\CoshipNMSClient.exe" (
echo ����ʧ�ܣ�δ����CoshipNMSClient.zipѹ������
goto out_erro
)
REM ****************************************

cd e:\nmsbuild\test-release
WinRAR a -r -afzip %FILENAME%.zip
svn import -m %4 "%FILENAME%.zip"  "http://192.168.99.101:9999/TestPackage/11_network/EOC-NMS/%FILENAME%.zip"
if errorlevel 1 (
echo �ϴ�ʧ�ܣ�
goto out_error
)
goto out

:out
echo  ���뼰�ϴ��ɹ�
exit 0

:out_error
exit 1


