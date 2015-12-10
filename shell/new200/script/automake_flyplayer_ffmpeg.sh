#!/bin/bash
#########write by xy 11/20/2013
prj=$1
workspace=$2
packagespace=$3

cd $workspace
. setupenv
make bin

cd $workspace
if [ -d release2test ]
then
	echo "compile ok"
else
	echo "compile error please check log" 
	exit 1
fi

######### get svn version and tar 
cd /home/hudson/$prj
creattime=`date +%Y%m%d%H%M`
filename=$prj\_$creattime

######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cd $packagespace
tar -cvf $workspace/output/$filename.tar.gz *





