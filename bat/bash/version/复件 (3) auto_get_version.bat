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
set flag=n
for /f "tokens=1-2 delims==" %%i in (%filename%) do (

set /a k+=1
echo  !k!

if !k! GEQ 2 (

echo %%j|find "10.10.5.166" && set flag=y
echo %%j|find "10.10.5.165" && set flag=y
echo %%j|find "10.10.5.52" && set flag=y

if "%flag%"=="n" echo ��ȷ��%%i�ĵ�ַ�Ƿ�����10.10.5.166����10.10.5.165����10.10.5.52 && goto errorout

)

)



:endsuccess

echo  OK��
pause

:errorout
echo  error��
pause

















