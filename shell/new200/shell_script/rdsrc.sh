#!/bin/sh
srcname=$1
dirname=/home/qiaoting/SRC/$srcname
cd $dirname
echo =========== dirname:$dirname current path:$(pwd) ============
if [ "$(pwd)" == "$dirname" ]
then
	echo =========== rd $srcname for next build ============
	rm git_src -rf
else
	echo =========== no such dir exits, exit now ============
fi
