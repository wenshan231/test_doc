
cd/d G:\CDN_R006\Transcode\develop\trunk
@REM *** get output  model_version***** 
SETLOCAL ENABLEDELAYEDEXPANSION

for /f "tokens=1-2 delims==" %%i in (G:\CDN_R006\Transcode\develop\trunk\package.sh) do (
if %%i==version set version=%%~j

)

echo %version%

pause