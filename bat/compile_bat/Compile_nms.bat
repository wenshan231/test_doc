@echo on
echo *************************************************************************
echo *                          编译并检查测试文件                           *
echo *************************************************************************

echo 各参数信息：
echo 1.产品型号：  %1
echo 2.测试包文件名称：  %2
echo 3.源代码类型：  %3
echo 4.源代码标签：  %4
echo 5.源代码路径：  %5

:: 设置变量
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
echo 生成便签失败
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
echo 编译失败，未生成CoshipNMSServer.tar.gz压缩包。
goto out_erro
)

if not exist "e:\nmsbuild\test-release\software\CoshipNMSClient.exe" (
echo 编译失败，未生成CoshipNMSClient.zip压缩包。
goto out_erro
)
REM ****************************************

cd e:\nmsbuild\test-release
WinRAR a -r -afzip %FILENAME%.zip
svn import -m %4 "%FILENAME%.zip"  "http://192.168.99.101:9999/TestPackage/11_network/EOC-NMS/%FILENAME%.zip"
if errorlevel 1 (
echo 上传失败！
goto out_error
)
goto out

:out
echo  编译及上传成功
exit 0

:out_error
exit 1


