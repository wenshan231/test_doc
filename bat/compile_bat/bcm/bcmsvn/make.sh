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
svn co $taglable $pro >> $prjpath/$pro/svnlog 2>&1
export LANG=zh_CN.GBK

cd $prjpath
chmod -Rf 777 $pro 
cd $prjpath/$pro

sh Automake.bat >> $prjpath/$pro/makelog 2>&1

