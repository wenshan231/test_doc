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
echo  !k!

if !k! GEQ 2 (
set f=0
echo %%j>D:\bash\version\%1\j.txt

find /c "10.10.5.166"  D:\bash\version\%1\j.txt
if "%errorlevel%"=="0"  set f=1
find /c "10.10.5.165"  D:\bash\version\%1\j.txt
if "%errorlevel%"=="0"  set f=1
echo %f%

find /c "10.10.5.52" D:\bash\version\%1\j.txt
if "%errorlevel%"=="0"  set f=1

if "!f!"=="n" echo ��ȷ��%%i�ĵ�ַ�Ƿ�����10.10.5.166����10.10.5.165����10.10.5.52 && goto errorout

)

)



:endsuccess

echo  OK��
pause

:errorout
echo  error��
pause

















