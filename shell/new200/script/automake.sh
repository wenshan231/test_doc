#!/bin/bash
#########write by qiaoting 4/15/2013
prj=$1
workspace=$2
packagespace=$3
cd $workspace
pwd
sh setupenv
make clean
make bin
echo $prj

######### get svn version and 
cd /home/hudson/$prj
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename
######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cd $packagespace
tar -cvf $workspace/output/$filename.tar.gz *








