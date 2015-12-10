#!/bin/bash
#########write by qiaoting 5/10/2013
prj=$1
workspace_dir=$2
workspace=$3
packagespace=$4
cd $workspace
pwd
chmod -R a+x * 
source  ./setupenv && make clean && make bin

##############

if [ -d $packagespace ]
then :
else
echo "build failed "
exit 1
fi


######### get svn version and 
cd $workspace_dir
#filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
#filename=$prj\_svn.`svnversion $workspace`_`date "+%Y%m%d%H%M%S"`
svn_version1=`sed -n 11p $workspace_dir/platform/.svn/entries`
svn_version2=`sed -n 11p $workspace/.svn/entries`
if [ $svn_version1 -gt $svn_version2 ]
then
	svn_version=$svn_version1
else
	svn_version=$svn_version2
fi
filename=$prj\_svn.$svn_version\_`date "+%Y%m%d%H%M%S"`


echo $filename
######### build file.zip
cd $workspace
rm -fr output
mkdir output

cd $workspace_dir/package && tar -cvf $workspace/output/package_$filename.tar.gz *


cd $packagespace
cp -f $workspace_dir/log_version.txt $packagespace/
zip -r  -0  $workspace/output/$filename.zip *
