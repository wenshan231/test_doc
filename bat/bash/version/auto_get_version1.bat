@REM �Զ���ȡ��������ύ��SVN
@REM  �벻Ҫɾ������
@REM �ж�ģ���������ܴ���10�������״��������д��
@REM 


set Mode-num=20
set filename=D:\bash\version\%1\version.txt

@REM *** get label and lable path ***** 
SETLOCAL ENABLEDELAYEDEXPANSION
set k=0



for /f "delims=" %%a in (%filename%) do (
set /a k+=1
echo !k!
if !k! LEQ %Mode-num%  set %%a


)



set k=0

for /f "tokens=1-2 delims==" %%i in (%filename%) do (
set /a k+=1
echo  %k%
echo %%j>D:\bash\version\%1\%k%.txt
)



echo %k%
for /f "tokens=1-2 delims==" %%i in (%filename%) do (
set /a k+=1
echo  %k%
echo %%j>D:\bash\version\%1\%k%.txt
)


find /c "10.10.5.166"  D:\bash\version\%1\%k%.txt
if "%errorlevel%"=="0" goto repeat
find /c "10.10.5.165"  D:\bash\version\%1\%k%.txt
if "%errorlevel%"=="0"  goto repeat


find /c "10.10.5.52" D:\bash\version\%1\%k%.txt
if "%errorlevel%"=="0"   goto repeat

goto errorout

:errorout
echo ��ȷ�ϵ�ַ�Ƿ�����10.10.5.166����10.10.5.165����10.10.5.52
pause


















