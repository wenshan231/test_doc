D:

if NOT exist %1  goto out_err_mdl
cd %1
if exist output  del /f /q /s  output
mkdir output

copy "sdp-core\target\*.jar"  "output\"

copy "sdp-log\target\*.jar"  "output\"
copy "sdp-permission\target\*.jar" "output\"
pause

exit 0

:out_err_mdl
REM ��·������ȷ�����ٴ�ȷ�ϣ�
pause
exit 1