#! /bin/bash
srcpath="$1"
echo $srcpath

if [ -d $srcpath ]
then
	echo "$srcpath�ļ�����"
	cd $srcpath
	sh install.sh
	exit 0
else 
	echo "$srcpath�ļ�������" 
	exit 1
fi