#! /bin/bash
mdl=$1
srcpath="$2"
echo $srcpath

if [ -d $srcpath/integration ]
then
	echo "$srcpath/integration文件存在"
	cd $srcpath/integration
	rm -rf  *.zip
	rm -rf  *.tar.gz
	cd $srcpath
	sh package.sh
	exit 0
else 
	echo "$srcpath/integration文件不存在" 
	exit 1
fi