#!/bin/bash

workspace=$1
apkname=$2
cd  /home/hudson/tools
svn up 

cd  /home/hudson/tools
svn up  --username qiaoting --password 789123

cd  /home/hudson/key
svn up  --username qiaoting --password 789123


cd $workspace
pwd
sh /opt/apache-ant-1.8.2/bin/ant  -Dwork.dir=. release

if [[ $? -ne 0 ]]
	then
	echo "compile error" 
	exit 1
fi
echo $workspace/bin/$apkname.apk

	if [ -f $workspace/bin/$apkname.apk ]
	then
	
		rm -fr output
		mkdir output
		cp -rf $workspace/bin/$apkname.apk   $workspace/output
		echo "apk to output  ok"
#########get svn version		
	filename=$apkname\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
	echo $filename

	######### build file.tar.gz
	
	cd $workspace/output
	tar -zcvf $workspace/output/$filename.tar.gz *					
  rm -f $apkname.apk
	exit 0
	else

		echo "compile error please check log" 
		exit 1
	fi









 
