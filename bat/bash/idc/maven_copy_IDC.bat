D:

if NOT exist %1  goto out_err_mdl
cd %1\idc
if exist output  del /f /q /s  output
mkdir  output

copy "bi-collectors\target\*.zip"  "output\"
copy "bi-dcms\dcms-jetty\target\*.zip"  "output\"
copy "bi-report\report-jetty\target\*.zip"  "output\"







pause

exit 0

:out_err_mdl
REM ��·������ȷ�����ٴ�ȷ�ϣ�
pause
exit 1