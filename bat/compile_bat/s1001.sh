#!/usr/bin/bash

prjpath=/luntbuild/work/stb
cd $prjpath
tagsrc=`cat colable`
export $tagsrc
echo $taglable
echo $pro
cd $prjpath
rm -fr $pro
mkdir $pro
svn co $taglable $pro >> $prjpath/$pro/svnlog
export LANG=zh_CN.GBK
export ANT_HOME=/opt/apache-ant-1.7.1
export JAVA_HOME=/opt/java/jdk1.5.0_11
export PATH=$PATH:$JAVA_HOME/bin:$ANT_HOME/bin


cd $prjpath/$pro
chmod -Rf 777  *

echo cd $prjpath/$pro >> $prjpath/$pro/makelog  2>&1
. setupenv >> $prjpath/$pro/makelog  2>&1 

make clean >> $prjpath/$pro/makelog  2>&1 
make bin >> $prjpath/$pro/makelog  2>&1 