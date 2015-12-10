@echo 		******************************************************
@echo 		           AnySight108 Compiling Testing Bat
@echo 		      Written by WangYan on Oct 19th, 2006
@echo                   Modify by youqingli on Sep 30th,2007
@echo 		******************************************************

@REM set initial variable
@set BATPATH=E:\DVB\DATA\AnySight108\AutoBuild

E:

REM Start Compiling AnySight108
cd "%BATPATH%\src"
if exist setenv.bat (
call setenv
@REM @pause
gmake clean
gmake
@REM @pause
@echo -----------------------------
@echo it's compile path is the root
@echo -----------------------------
goto end
) else if exist ST5105 (
cd ST5105
call setenv
@REM @pause
gmake clean
gmake
@REM @pause
@echo ----------------------------
@echo it's compile path is ST5105
@echo ----------------------------
goto end
)

:end
@REM @pause