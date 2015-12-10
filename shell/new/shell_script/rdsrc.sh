#!/bin/sh
srcname=$1
dirname=/home/qiaoting/SRC/$srcname
cd $dirname
echo =========== dirname:$dirname current path:$(pwd) ============
if [ "$(pwd)" == "$dirname" ]
then
	echo =========== rd $srcname for next build ============
	ls | grep -v .git | grep -v output | xargs rm -rf 
else
	echo =========== no such dir exits, exit now ============
fi
