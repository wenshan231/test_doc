#! /bin/bash

prj=$1
workspace=$2
packagespace=$3
envname=$4
echo $envname


cd $workspace
#export LANG=zh_CN.GBK
export JAVA_HOME=/opt/java/jdk1.6.0_45
export ANT_HOME=/opt/apache-ant-1.7.1
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$ANT_HOME/bin:$PATH

svnreversion=`svn info  $workspace| grep "^最后修改的修订版\| grep ^最后修改的版本: \|^Last Changed Rev: "|grep -Eo '[0-9]+'`
creattime=`date +%Y%m%d%H`

	\rm -rf release2test
	. $envname
	make clean
	make bin


if [ -d $packagespace ]
then :
else
echo "build failed "
exit 1
fi

cd $workspace
filename=$prj\_$envname\_svn.`sed -n 11p .svn/entries `_`date "+%Y%m%d%H%M%S"`
echo $filename


######### build file.tar.gz
cd $workspace
rm -fr output
mkdir output
cp -r $packagespace/gz output
##拷贝版本信息到release2test后打包
cd $workspace
svn info > package/product.txt
cp package/*.txt $packagespace
cp package/*.txt output
#cp package/*_manifest.xml $packagespace
cp package/*_manifest.xml output
cd $packagespace
rar a $workspace/output/$filename.rar *
