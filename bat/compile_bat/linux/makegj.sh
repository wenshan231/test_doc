#!/usr/bin/bash

prjpath=/luntbuild/work/stb
cd $prjpath
tagsrc=`cat colable`
export $tagsrc
echo $taglable
echo $pro
echo $srcpath
cd $prjpath
rm -fr $pro
mkdir $pro
svn co $taglable $pro >> $prjpath/$pro/svnlog 2>&1
export LANG=zh_CN.GBK

cd $prjpath
chmod -Rf 777 $pro 
cd $prjpath/$pro/$srcpath
mv AutoBuild.bat build.sh
 . build.sh  >> $prjpath/$pro/makelog 2>&1

