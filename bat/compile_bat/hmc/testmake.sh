#!/bin/bash
#cd /luntbuild/work/mmcp/trunk/integration/stb/iptv
#prjpath=/home/public/automake/hmc2
prjpath=/luntbuild/work/stb/hmc2

LIBPATH=$(pwd)/share/lib

cd $prjpath
tagsrc=`cat colable1`
export $tagsrc
echo $taglable
echo $prj
cd $prjpath
# rm -fr $prj
# mkdir $prj
# svn co $taglable $prj  >> $prjpath/$prj/makelog
export ANT_HOME=/opt/apache-ant-1.7.1
export JAVA_HOME=/opt/java/jdk1.5.0_11
export PATH=$PATH:$JAVA_HOME/bin:$ANT_HOME/bin
export LANG=zh_CN.GBK


# sh /opt/apache-ant-1.7.1/bin/ant -propertyfile basepath.properties  >> $prjpath/makelog  2>&1 
cd $prjpath/$prj
chmod -R 777  *
echo $prjpath >> $prjpath/$prj/makelog
echo $prj >> $prjpath/$prj/makelog
cd $prjpath/$prj/product/$prj
. setupenv >> $prjpath/$prj/makelog  2>&1
make clean >> $prjpath/$prj/makelog  2>&1
echo "********make bin**********"  >> $prjpath/$prj/makelog  2>&1
make -C javacode >> $prjpath/$prj/makelog  2>&1
make -C native >> $prjpath/$prj/makelog  2>&1
make appbin >> $prjpath/$prj/makelog  2>&1
	
cd $prjpath/$prj/product/$prj/release2test
find -name ".svn" -exec rm -fr {} \;

