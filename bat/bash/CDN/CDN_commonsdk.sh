#! /bin/bash
srcpath="$1"
echo $srcpath

if [ -d $srcpath ]
then
	echo "$srcpath文件存在"
	cd $srcpath
	sh install.sh
	exit 0
else 
	echo "$srcpath文件不存在" 
	exit 1
fi