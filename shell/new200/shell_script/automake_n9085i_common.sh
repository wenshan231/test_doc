#!/bin/bash
#########write by qiaoting 4/15/2013
prj=$1
workspace=$2
packagespace=$3
packagespace_int=$4
prj_env=$5

cd $workspace
chmod -R 775 *
source ./setupenv $prj_env && make clean && make bin 

if [ -d $packagespace ]
then :
echo "build $packagespace OK"
else
echo "build failed "
exit 1
fi


if [ -d $packagespace_int ]
then :
echo "build $packagespace_int OK"
else
echo "build for int failed "
exit 1
fi

######### get svn version and tar 
cd /home/hudson/$prj
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename
echo $filename_int
######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cd $packagespace
tar -cvf $workspace/output/$filename.tar.gz *
cd $packagespace_int
cp $packagespace_int/mt8658sdkcoship.tar.gz $workspace/output/
cd $workspace/output
tar -cvf $workspace/output/$filename\_int.tar.gz mt8658sdkcoship.tar.gz && rm -f mt8658sdkcoship.tar.gz 







