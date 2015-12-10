#! /bin/bash

prj=$1
workspace=$2
packagespace=$3

chmod -Rf 777 *

sh 96D-bin-all.sh

if [ -d $packagespace ]
then :
else
echo "build failed "
exit 1
fi

cd $workspace
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename


######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cd $packagespace  
tar -czvf $workspace/output/$filename.tar.gz *