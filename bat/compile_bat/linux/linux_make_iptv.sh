#!/usr/bin/bash
prjpath=/home/weijiang/linux
echo test1 >/home/weijiang/linux/weijiang.log
cd $prjpath 
tagsrc=`cat colable`
export $tagsrc 
echo $taglable   >>/home/weijiang/linux/weijiang.log
echo $pro >>/home/weijiang/linux/weijiang.log
echo $path >>/home/weijiang/linux/weijiang.log

cd $prjpath
chmod -R 777 $pro
rm -rf $pro 
svn co $taglable $pro >>/home/weijiang/linux/svn.log
echo `pwd` /home/weijiang/linux/weijiang.log
echo test2 >>/home/weijiang/linux/weijiang.log

cd $prjpath
echo `pwd` /home/weijiang/linux/weijiang.log
chmod -R 777 $pro 
cd $prjpath/$pro/

. AutoBuild.bat >>/home/weijiang/linux/weijiang.log
echo test3 >>/home/weijiang/linux/weijiang.log
