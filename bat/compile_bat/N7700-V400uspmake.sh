#!/usr/bin/bash

prjpath=/luntbuild/work/stb
cd $prjpath
tagsrc=`cat colable`
export $tagsrc
echo $taglable
echo $pro
if [ "$pro" == "/" ]
then
echo ·��Ϊ"/"�ǷǷ�·��,���޸������ύ> $prjpath/$prj1/makelog 2>&1
exit
fi
cd $prjpath
rm -fr $pro
mkdir $pro
svn co $taglable $pro >> $prjpath/$pro/svnlog
export LANG=zh_CN.GBK

cd $prjpath
chmod -Rf 777 $pro 
cd $prjpath/$pro

. Automake.bat >> $prjpath/$pro/makelog 2>&1

