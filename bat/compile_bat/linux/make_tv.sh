#!/usr/bin/bash
#####  编译电视软件编译脚本
prjpath=/luntbuild/work/stb

cd $prjpath
#chmod -R 777  *
tagsrc=`cat colable`
export $tagsrc
echo $taglable
echo $pro

cd $prjpath
if [ "$pro" == "/" ]
then
echo 路径为"/"是非法路径,请修改重新提交> $prjpath/$prj1/makelog 2>&1
exit
fi
rm -fr $pro
mkdir $pro
svn co $taglable $pro  > $prjpath/$prj1/makelog 2>&1
export PATH=/opt/toolchains/tv/aeon/bin:/opt/toolchains/tv/mips-4.3/bin:/opt/toolchains/tv/montavista/pro/devkit/mips/mips2_fp_le/bin:/opt/toolchains/tv/crosstool/mipsel-gcc-4.1.2-uclibc-0.9.28.3-mips32/bin:/opt/toolchains/tv/aeon/bin:$PATH

cd $prjpath/$pro
chmod -R 777  *


make clean >> $prjpath/$pro/makelog  2>&1 
make >> $prjpath/$pro/makelog  2>&1 
echo test2 >> $prjpath/$pro/makelog  2>&1
