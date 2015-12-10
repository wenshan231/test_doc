#! /bin/bash

prj=$1
workspace=$2
packagespace=$3

cd $workspace
svn co svn://192.168.99.107/hmc/src/branches/Android_Application_Dev/Application/key --username=liuya --password=ly060810
svn co svn://192.168.99.107/hmc/src/branches/Android_Application_Dev/Application/other_source --username=liuya --password=ly060810
svn co svn://192.168.99.107/hmc/src/branches/Android_Application_Dev/Application/tools --username=liuya --password=ly060810

cd $workspace/trunk/$prj
#export LANG=zh_CN.GBK
export JAVA_HOME=/opt/java/jdk1.6.0_45
export ANT_HOME=/opt/apache-ant-1.7.1
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$ANT_HOME/bin:$PATH

        svnreversion=`svn info  $workspace/trunk/$prj| grep "^最后修改的修订版\| grep ^最后修改的版本: \|^Last Changed Rev: "|grep -Eo '[0-9]+'`
	creattime=`date +%Y%m%d%H`

	sed -i "s/android:versionName=\"1.0\"/android:versionName=\"$creattime\_svn\_$svnreversion\"/g" AndroidManifest.xml
	\rm -rf bin gen
	ant -Dwork.dir=. clean 
    	ant -Dwork.dir=. release  

if [ -d $packagespace ]
then :
else
echo "build failed "
exit 1
fi

cd $workspace/trunk/$prj
filename=$prj\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename


######### build file.tar.gz
cd $workspace/trunk/$prj
rm -fr output
mkdir output
cd output
#mkdir $filename
cd $packagespace
#tar -czvf $workspace/trunk/$prj/output/$filename.tar.gz *
cp -r * $workspace/trunk/$prj/output/