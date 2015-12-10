#!/bin/bash
#########write by qiaoting 5/10/2013
prj=$1
workspace_dir=$2
workspace=$3
packagespace=$4
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
cd $workspace_dir
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename
######### build file.zip
cd $workspace
rm -fr output
mkdir output
cd $packagespace
zip -r $workspace/output/package_$filename.zip *

