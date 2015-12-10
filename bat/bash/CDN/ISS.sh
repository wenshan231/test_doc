#! /bin/bash
mdl=$1
srcpath="$2"
echo $srcpath
cd $srcpath
cd integration

if [ -d $srcpath/integration ]
then
	echo "$srcpath/integration文件存在"
	cd $srcpath/integration
	rm -rf  *
	cd $srcpath
	rm -f   logfile*
	sh build.sh --check
	exit 0
else 
	echo "$srcpath/integration文件不存在" 
	exit 1
fi



 