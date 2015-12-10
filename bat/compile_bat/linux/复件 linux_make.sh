#!/usr/bin/bash
#cd /luntbuild/work/mmcp/trunk/integration/stb/iptv
prjpath=/luntbuild/work/stb/linux
rm -f $prjpath/logfile.txt
logfile=$prjpath/logfile.txt

cd $prjpath 
tagsrc=`cat colable` 
export $tagsrc 
echo $taglable 
echo $pro
echo $path

cd $prjpath 
rm -fr $pro 
mkdir $pro 
svn co $taglable $pro >> $prjpath/$pro/makelog 2>&1
export ANT_HOME=/opt/apache-ant-1.7.1
export JAVA_HOME=/opt/java/jdk1.5.0_11
export PATH=$PATH:$JAVA_HOME/bin:$ANT_HOME/bin
export LANG=zh_CN.GBK

cd $prjpath
chmod -R 777 $pro 
cd $prjpath/$pro/$path

sh AutoBuild.bat >> $prjpath/$pro/makelog 2>&1

#./make clean  >> $prjpath/$prj/makelog  2>&1 
#./make  >> $prjpath/$prj/makelog  2>&1 
#./make release >> $prjpath/$prj/makelog  2>&1 

#./setup
#./make distclean >> $prjpath/$prj/makelog  2>&1 
#./make >> $prjpath/$prj/makelog  2>&1 
#./make release >> $prjpath/$prj/makelog  2>&1 


