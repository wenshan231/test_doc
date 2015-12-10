#!/bin/bash
#########write by qiaoting 4/15/2013
prj=$1
workspace=$2
packagespace=$3
cd $workspace
pwd
source  ./setupenv
make clean
make bin


##############

if [ -d $packagespace ]
then :
else
echo "build failed "
exit 1
fi


######### get svn version and 
cd /home/hudson/$prj
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename
######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cd $workspace/package
tar -czvf $workspace/output/package_$filename.tar.gz *
cd $packagespace  
cp -f $workspace/log_version.txt $packagespace 
tar -czvf $workspace/output/$filename.tar.gz *









