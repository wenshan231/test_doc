#!/bin/bash


prj=$1
workspace=$2
packagespace=$3
makelog=/home/hudson/$prj/makelog
cd $workspace

pwd
. setupenv > $makelog 2>&1
make clean >> $makelog 2>&1
make bin >> $makelog 2>&1
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








