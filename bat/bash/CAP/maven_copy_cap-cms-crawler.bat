D:

if NOT exist %1  goto out_err_mdl
cd %1
if exist output  del /f /q /s  output
mkdir  output

copy "jetty-standalone\target\*.tar.gz"  "output\"



pause

exit 0

:out_err_mdl
REM ��·������ȷ�����ٴ�ȷ�ϣ�
pause
exit 1