#!/usr/bin/bash
prjpath=/luntbuild/work/stb/hmc2

cd $prjpath
#chmod -R 777  *
tagsrc=`cat colable`
export $tagsrc
echo $taglable
echo $prj1
echo $prj2

cd $prjpath
if [ "$prj1" == "/" ]
then
echo 路径为"/"是非法路径,请修改重新提交> $prjpath/$prj1/makelog 2>&1
exit
fi
rm -fr $prj1
mkdir $prj1
svn co $taglable $prj1  > $prjpath/$prj1/makelog 2>&1
export ANT_HOME=/opt/apache-ant-1.7.1
export JAVA_HOME=/opt/java/jdk1.5.0_11
export PATH=$PATH:$JAVA_HOME/bin:$ANT_HOME/bin
#export LANG=zh_CN.GBK

cd $prjpath/$prj1
echo $prjpath/$prj1 >> $prjpath/$prj1/makelog  2>&1
chmod -R 777  *
cd $prjpath/$prj1/product/$prj1/$prj2
echo $prjpath/$prj1/product/$prj1/$prj2 >> $prjpath/$prj1/makelog  2>&1
. setupenv >> $prjpath/$prj1/makelog  2>&1 

make clean >> $prjpath/$prj1/makelog  2>&1 
make bin >> $prjpath/$prj1/makelog  2>&1 
echo test2 >> $prjpath/$prj1/makelog  2>&1

cd $prjpath/$prj1/product/$prj1/$prj2/release2test
chmod -R 777 *
find -name ".svn" -exec rm -fr {} \;

